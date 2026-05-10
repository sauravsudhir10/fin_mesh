(fin-mesh) PS D:\Projects\fin_mesh> aws iam list-roles --query "Roles[*].RoleName"
File association not found for extension .py
[
    "aws-glue-notebook-rule",
    "AWSServiceRoleForOrganizations",
    "AWSServiceRoleForResourceExplorer",
    "AWSServiceRoleForSupport",
    "AWSServiceRoleForTrustedAdvisor",
    "aws_glue_service_roll",
    "cdk-hnb659fds-cfn-exec-role-754030094302-us-east-1",
    "cdk-hnb659fds-deploy-role-754030094302-us-east-1",
    "cdk-hnb659fds-file-publishing-role-754030094302-us-east-1",
    "cdk-hnb659fds-image-publishing-role-754030094302-us-east-1",
    "cdk-hnb659fds-lookup-role-754030094302-us-east-1"
]
(fin-mesh) PS D:\Projects\fin_mesh> cdk deploy                                                                    
                                        
✨  Synthesis time: 13.03s

FinMeshStack: creating CloudFormation changeset...
Changeset arn:aws:cloudformation:us-east-1:754030094302:changeSet/cdk-deploy-change-set/8f9ce755-7f9a-4bec-b394-78655f6597e2 created and waiting in review for manual execution (--no-execute)
Stack FinMeshStack
IAM Statement Changes
┌───┬──────────────────────────────────┬────────┬────────────────┬──────────────────────────────────┬───────────┐
│   │ Resource                         │ Effect │ Action         │ Principal                        │ Condition │
├───┼──────────────────────────────────┼────────┼────────────────┼──────────────────────────────────┼───────────┤
│ + │ ${FinMeshLFAdminRole.Arn}        │ Allow  │ sts:AssumeRole │ Service:lakeformation.amazonaws. │           │
│   │                                  │        │                │ com                              │           │
│ + │ ${FinMeshLFAdminRole.Arn}        │ Allow  │ sts:AssumeRole │ AWS:arn:${AWS::Partition}:iam::7 │           │
│   │                                  │        │                │ 54030094302:root                 │           │
└───┴──────────────────────────────────┴────────┴────────────────┴──────────────────────────────────┴───────────┘
IAM Policy Changes
┌───┬───────────────────────┬─────────────────────────────────────────────────────────────────┐
│   │ Resource              │ Managed Policy ARN                                              │
├───┼───────────────────────┼─────────────────────────────────────────────────────────────────┤
│ + │ ${FinMeshLFAdminRole} │ arn:${AWS::Partition}:iam::aws:policy/AWSLakeFormationDataAdmin │
│ + │ ${FinMeshLFAdminRole} │ arn:${AWS::Partition}:iam::aws:policy/AWSGlueConsoleFullAccess  │
└───┴───────────────────────┴─────────────────────────────────────────────────────────────────┘
(NOTE: There may be security-related changes not in this list. See https://github.com/aws/aws-cdk/issues/1299)


"--require-approval" is enabled and stack includes security-sensitive updates: Do you wish to deploy these changes? (y/n) y
FinMeshStack: deploying... [1/1]
FinMeshStack | 0/3 | 11:12:10 am | REVIEW_IN_PROGRESS   | AWS::CloudFormation::Stack | FinMeshStack User Initiated
FinMeshStack | 0/3 | 11:16:55 am | CREATE_IN_PROGRESS   | AWS::CloudFormation::Stack | FinMeshStack User Initiated
FinMeshStack | 0/3 | 11:16:57 am | CREATE_IN_PROGRESS   | AWS::IAM::Role             | FinMeshLFAdminRole (FinMeshLFAdminRoleB1DC8C6B) 
FinMeshStack | 0/3 | 11:16:57 am | CREATE_IN_PROGRESS   | AWS::CDK::Metadata         | CDKMetadata/Default (CDKMetadata) 
FinMeshStack | 0/3 | 11:16:58 am | CREATE_IN_PROGRESS   | AWS::IAM::Role             | FinMeshLFAdminRole (FinMeshLFAdminRoleB1DC8C6B) Resource creation Initiated
FinMeshStack | 0/3 | 11:16:58 am | CREATE_IN_PROGRESS   | AWS::CDK::Metadata         | CDKMetadata/Default (CDKMetadata) Resource creation Initiated
FinMeshStack | 1/3 | 11:16:58 am | CREATE_COMPLETE      | AWS::CDK::Metadata         | CDKMetadata/Default (CDKMetadata) 
FinMeshStack | 2/3 | 11:17:16 am | CREATE_COMPLETE      | AWS::IAM::Role             | FinMeshLFAdminRole (FinMeshLFAdminRoleB1DC8C6B) 
FinMeshStack | 3/3 | 11:17:17 am | CREATE_COMPLETE      | AWS::CloudFormation::Stack | FinMeshStack 

 ✅  FinMeshStack

✨  Deployment time: 30.65s

Outputs:
FinMeshStack.FinMeshLFAdminRoleArn = arn:aws:iam::754030094302:role/finmesh-lf-admin
FinMeshStack.FinMeshLFAdminRoleName = finmesh-lf-admin
Stack ARN:
arn:aws:cloudformation:us-east-1:754030094302:stack/FinMeshStack/fd3ac900-4c32-11f1-94de-0e9f8c44e4cf

✨  Total time: 43.68s