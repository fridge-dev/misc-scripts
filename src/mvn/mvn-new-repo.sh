mvn archetype:generate \
    -DgroupId=com.frj \
    -DartifactId=CreateUserLambda

(interactive mode):

command+f for this line:

96: remote -> com.amazonaws:aws-java-sdk-archetype (Maven archetype for a simple AWS Java application.)

Example run:


Choose a number or apply filter (format: [groupId:]artifactId, case sensitive contains): 1476: 96
Choose com.amazonaws:aws-java-sdk-archetype version: 
1: 1.0.0
2: 1.0.1
Choose a number: 2: 2
[INFO] Using property: groupId = com.frj
[INFO] Using property: artifactId = CreateUserLambda
Define value for property 'version' 1.0-SNAPSHOT: : 
[INFO] Using property: package = com.frj
Confirm properties configuration:
groupId: com.frj
artifactId: CreateUserLambda
version: 1.0-SNAPSHOT
package: com.frj
 Y: : 
[INFO] ----------------------------------------------------------------------------
[INFO] Using following parameters for creating project from Archetype: aws-java-sdk-archetype:1.0.1
[INFO] ----------------------------------------------------------------------------
[INFO] Parameter: groupId, Value: com.frj
[INFO] Parameter: artifactId, Value: CreateUserLambda
[INFO] Parameter: version, Value: 1.0-SNAPSHOT
[INFO] Parameter: package, Value: com.frj
[INFO] Parameter: packageInPathFormat, Value: com/frj
[INFO] Parameter: package, Value: com.frj
[INFO] Parameter: groupId, Value: com.frj
[INFO] Parameter: artifactId, Value: CreateUserLambda
[INFO] Parameter: version, Value: 1.0-SNAPSHOT
[INFO] Project created from Archetype in dir: /Users/alecva/workspace/fridge-dev/CreateUserLambda
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 31.995 s
[INFO] Finished at: 2020-02-13T23:24:12-08:00
[INFO] Final Memory: 15M/54M
[INFO] ------------------------------------------------------------------------


This is the target end state:

https://github.com/fridge-dev/CreateUserLambda/commit/2c33ca3e72e4cd5de28bedddafe9fa59ecaf2d8b
