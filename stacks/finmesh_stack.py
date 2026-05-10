"""
FinMesh IAM Stack - Creates Lake Formation admin role with necessary permissions
"""
import aws_cdk as cdk
from aws_cdk import (
    aws_iam as iam,
)
from constructs import Construct


class FinMeshStack(cdk.Stack):
    """Stack for FinMesh AWS resources including IAM roles for Lake Formation"""

    def __init__(
        self,
        scope: Construct,
        construct_id: str,
        **kwargs,
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Create the trust policy document
        trust_policy = iam.PolicyDocument(
            statements=[
                iam.PolicyStatement(
                    effect=iam.Effect.ALLOW,
                    principals=[
                        iam.ServicePrincipal("lakeformation.amazonaws.com")
                    ],
                    actions=["sts:AssumeRole"],
                ),
                iam.PolicyStatement(
                    effect=iam.Effect.ALLOW,
                    principals=[iam.AccountRootPrincipal()],
                    actions=["sts:AssumeRole"],
                ),
            ]
        )

        # Create the IAM role with the trust policy
        self.finmesh_lf_admin_role = iam.Role(
            self,
            "FinMeshLFAdminRole",
            assumed_by=iam.CompositePrincipal(
                iam.ServicePrincipal("lakeformation.amazonaws.com"),
                iam.AccountPrincipal(self.account),
            ),
            role_name="finmesh-lf-admin",
            description="Role for FinMesh Lake Formation administration",
        )

        # Attach AWS managed policies
        self.finmesh_lf_admin_role.add_managed_policy(
            iam.ManagedPolicy.from_aws_managed_policy_name(
                "AWSLakeFormationDataAdmin"
            )
        )
        self.finmesh_lf_admin_role.add_managed_policy(
            iam.ManagedPolicy.from_aws_managed_policy_name(
                "AWSGlueConsoleFullAccess"
            )
        )

        # Output the role ARN
        cdk.CfnOutput(
            self,
            "FinMeshLFAdminRoleArn",
            value=self.finmesh_lf_admin_role.role_arn,
            description="ARN of the FinMesh Lake Formation Admin Role",
        )

        cdk.CfnOutput(
            self,
            "FinMeshLFAdminRoleName",
            value=self.finmesh_lf_admin_role.role_name,
            description="Name of the FinMesh Lake Formation Admin Role",
        )
