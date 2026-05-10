#!/usr/bin/env python3
"""
FinMesh AWS CDK App - Infrastructure as Code for Data Mesh on AWS Lake Formation
"""
import yaml
import aws_cdk as cdk
from pathlib import Path
from stacks.finmesh_stack import FinMeshStack


def load_config(config_path: str = "config.yaml") -> dict:
    """Load configuration from YAML file"""
    with open(config_path, "r") as f:
        return yaml.safe_load(f)


def main():
    """Main entry point for the CDK app"""
    # Load configuration
    config = load_config()
    account_id = str(config.get("accountId"))

    if not account_id or account_id == "YOUR_ACCOUNT_ID":
        raise ValueError(
            "Invalid or placeholder account ID in config.yaml. "
            "Please update the 'accountId' field with your actual AWS account ID."
        )

    # Create the CDK app
    app = cdk.App()

    # Create the FinMesh stack
    FinMeshStack(
        app,
        "FinMeshStack",
        env=cdk.Environment(
            account=account_id,
            region=config.get("region", "us-east-1"),
        ),
    )

    app.synth()


if __name__ == "__main__":
    main()
