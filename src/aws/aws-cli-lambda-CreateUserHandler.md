# Resource Creation

Because I am too lazy to learn CloudFormation.

## User Auth

### Shared DynamoDB tables

Create the DynamoDB tables

```
TABLE_NAME=UserLogin
HASH_KEY=Username
aws dynamodb create-table \
    --table-name $TABLE_NAME \
    --attribute-definitions AttributeName=$HASH_KEY,AttributeType=S \
    --key-schema AttributeName=$HASH_KEY,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

aws dynamodb describe-table --table-name $TABLE_NAME
USER_LOGIN_TABLE_ARN=`aws dynamodb describe-table --table-name $TABLE_NAME | jq -r ".Table.TableArn"`
```

### CreateUserHandler

1. Create the IAM resources with basic Lambda privileges (logs) and DDB PutItem
1. Create the Lambda function

```
FUNCTION_NAME=CreateUserHandler
```

#### IAM

Create Policy

```
[ -n "$FUNCTION_NAME" ] \
&& [ -n "$USER_LOGIN_TABLE_ARN" ] \
&& cat > ./$FUNCTION_NAME-Policy.txt <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-west-2:645154635593:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "dynamodb:UpdateItem"
            ],
            "Resource": [
                "arn:aws:logs:us-west-2:645154635593:log-group:/aws/lambda/$FUNCTION_NAME:*",
                "$USER_LOGIN_TABLE_ARN"
            ]
        }
    ]
}
EOL

CREATE_POLICY_JSON=`aws iam create-policy --policy-name LambdaExecutionPolicy-$FUNCTION_NAME --policy-document file://./$FUNCTION_NAME-Policy.txt`
echo $CREATE_POLICY_JSON | jq
POLICY_ARN=`echo $CREATE_POLICY_JSON | jq -r ".Policy.Arn"`

# Read your own write
aws iam get-policy --policy-arn $POLICY_ARN
aws iam get-policy-version --version-id v1 --policy-arn $POLICY_ARN
```

Create Role

```
[ -n "$FUNCTION_NAME" ] \
&& cat > ./$FUNCTION_NAME-Role.txt <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOL

ROLE_NAME=LambdaExecutionRole-$FUNCTION_NAME
CREATE_ROLE_JSON=`aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://./$FUNCTION_NAME-Role.txt`
echo $CREATE_ROLE_JSON | jq
ROLE_ARN=`echo $CREATE_ROLE_JSON | jq -r ".Role.Arn"`


# Read your own write
aws iam get-role --role-name $ROLE_NAME
```

Attach Policy to the Role

```
[ -n "$FUNCTION_NAME" ] && \
[ -n "$POLICY_ARN" ] && \
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn $POLICY_ARN

# Read your own write
aws iam list-entities-for-policy --policy-arn $POLICY_ARN
aws iam list-attached-role-policies --role-name $ROLE_NAME
```

#### Lambda

First run `mvn install` then create the function with the JAR.

```
aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime java11 \
    --handler com.frj.auth.CreateUserHandler \
    --zip-file fileb://./target/CreateUserLambda-1.0-SNAPSHOT.jar \
    --role $ROLE_ARN \
    --timeout 15 \
    --memory-size 256
```

# Updates

**Config update**

```
aws lambda update-function-configuration \
    --function-name CreateUserHandler \
    --handler com.frj.auth.lambda.CreateUserInvokeHandler
```

**Code update**

```
./lambda-deploy-current-workspace.sh
```

**Test Invoke**

```
./lambda-invoke-test.sh myusername 012345
```
