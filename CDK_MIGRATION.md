# FinMesh CDK Deployment Guide

This project uses AWS CDK (Infrastructure as Code) to manage AWS resources for the FinMesh data mesh on AWS Lake Formation.

## Prerequisites

- Python 3.10 or higher
- AWS CLI configured with appropriate credentials
- uv package manager (or pip)

## Setup

### 1. Install dependencies

```bash
# Using uv (recommended)
uv sync

# Or using pip
pip install -r requirements.txt
```

### 2. Configure your AWS account

Edit `config.yaml` and ensure your AWS account ID is set:

```yaml
accountId: YOUR_AWS_ACCOUNT_ID
region: us-east-1  # Change to your desired region
```

### 3. Bootstrap CDK Environment (Required - One Time Only)

Before deploying with CDK for the first time, you must bootstrap your AWS account and region:

```bash
cdk bootstrap
```

This creates the necessary CloudFormation stack and S3 bucket that CDK needs for deployment. **This only needs to be run once per AWS account/region combination.**

If you deploy to a different region, you'll need to bootstrap that region as well:

```bash
cdk bootstrap aws://<account-id>/<region>
```

## Usage

### Prerequisites for CDK Commands

Ensure AWS CDK is installed globally via npm:

```bash
npm install -g aws-cdk
```

### Manual CDK Commands

Run CDK commands directly in the terminal:

```bash
# Synthesize CloudFormation template
cdk synth
```

This generates a CloudFormation template from the CDK code.

```bash
# Preview changes before deployment
cdk diff
```

This shows what CloudFormation resources will be created/modified.

```bash
# Deploy to AWS
cdk deploy
```

This will:
1. Show you a summary of changes
2. Ask for confirmation
3. Deploy the CloudFormation stack to your AWS account
4. Create the `finmesh-lf-admin` IAM role with:
   - Lake Formation admin permissions
   - Glue console full access
   - Trust policy allowing the Lake Formation service and account root to assume the role

### View stack outputs

After deployment, the stack outputs will show:
- `FinMeshLFAdminRoleName`: The name of the created IAM role
- `FinMeshLFAdminRoleArn`: The ARN of the created IAM role

### Destroy stack (if needed)

```bash
cdk destroy
```

This will delete all resources created by this stack.

## Project Structure

```
.
├── app.py                    # CDK app entry point (loads config and creates stack)
├── stacks/
│   ├── __init__.py
│   └── finmesh_stack.py     # FinMesh stack definition (IAM roles, policies)
├── config.yaml              # Configuration file (account ID, region)
├── cdk.json                 # CDK configuration
├── pyproject.toml           # Python dependencies
└── requirements.txt         # pip dependencies (alternative to pyproject.toml)
```

## Customization

To add more AWS resources:

1. Edit `stacks/finmesh_stack.py`
2. Add new resource definitions using CDK constructs
3. Run `cdk diff` to preview changes
4. Run `cdk deploy` to apply changes

Example resources you could add:
- Lake Formation data lake setup
- Glue database and tables
- S3 buckets for data
- Additional IAM roles and policies
