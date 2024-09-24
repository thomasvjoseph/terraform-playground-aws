# Terraform AWS Infrastructure

This repository contains Terraform code to build AWS infrastructure for three environments: Development (Dev), Quality Assurance (QA), and Production (Prod). The directory structure is organized as follows:

```
terraform-aws-infrastructure/
├── .github/workflows                 # CircleCI pipeline configuration
├── environments/              # Environment-specific configurations
│   ├── dev/
│   │   ├── main.tf            # Main Terraform configuration for Dev environment
│   │   ├── output.tf          # Output configuration for Dev environment
│   │   ├── provider.tf        # Provider configuration for Dev environment
│   │   ├── terraform.tfvars   # Terraform variables for Dev environment
│   │   └── variables.tf       # Variable declarations for Dev environment
│   ├── qa/
│   │   ├── main.tf            # Main Terraform configuration for QA environment
│   │   ├── output.tf          # Output configuration for QA environment
│   │   ├── provider.tf        # Provider configuration for QA environment
│   │   ├── terraform.tfvars   # Terraform variables for QA environment
│   │   └── variables.tf       # Variable declarations for QA environment
│   └── prod/
│       ├── main.tf            # Main Terraform configuration for Prod environment
│       ├── output.tf          # Output configuration for Prod environment
│       ├── provider.tf        # Provider configuration for Prod environment
│       ├── terraform.tfvars   # Terraform variables for Prod environment
│       └── variables.tf       # Variable declarations for Prod environment
└── modules/                    # Terraform modules for AWS services
    ├── ACM/
    ├── EBS/
    ├── EC2/
    ├── ECR/
    ├── ECS/
    ├── IAM/
    ├── LB/
    ├── RDS/
    ├── S3/
    ├── SG/
    ├── VPC/
    ├── CloudFront/
    ├── CloudWatch/
    ├── CodeBuild/
    └── KeyPair/
```

Each environment folder (`dev`, `qa`, `prod`) contains Terraform configuration files (`main.tf`, `output.tf`, `provider.tf`, `terraform.tfvars`, `variables.tf`) specific to that environment. Similarly, the `modules` directory contains modules for various AWS services, each with its own `main.tf`, `variable.tf`, and `output.tf`.

## Managing Terraform State with S3 Backend

Terraform state is managed using an S3 backend. Below are the steps to configure the S3 backend for your environment.

### Backend Configuration

In your Terraform configuration files (`main.tf`), define the S3 backend as follows:

```hcl
terraform {
  backend "s3" {
    encrypt = true
    bucket  = "<account_id>-terraform-states"
    key     = "development/service-name.tfstate"
    region  = "<region>"
    dynamodb_table = "terraform-lock"
  }
}
```

### Environment-specific Configuration

For each environment, define the backend configuration in a separate file (`backend-dev.conf`, `backend-qa.conf`, `backend-prod.conf`) as shown below:

```hcl
# backend-dev.conf
bucket  = "<account_id>-terraform-states"
key     = "development/service-name.tfstate"
encrypt = true
region  = "<region>"
dynamodb_table = "terraform-lock"
```

### Notes on S3 Backend

- **Bucket**: Use an existing S3 bucket. Ensure that the bucket name is globally unique.
- **Key**: Assign meaningful names for different services or applications to avoid conflicts.
- **DynamoDB Table**:You can specify a DynamoDB table for state locking.

## Secrets Management

Avoid hardcoding sensitive information such as keys, usernames, and passwords. Instead, utilize AWS Secrets Manager for secure storage and retrieval of secrets.

## Pipeline

The `.github/workflows` directory contains configuration for setting up the CircleCI & GitHub Acctions pipeline for automated infrastructure deployment. Use accrrodingly.

## Run locally

To run the Terraform code on your local PC, you'll need to follow these steps:

### Prerequisites:

1. Install Terraform: Download and install Terraform from the [official website](https://www.terraform.io/downloads.html) for your operating system.

2. Set up AWS credentials: Ensure you have valid AWS credentials configured locally. You can set them up using the AWS CLI or by configuring environment variables (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).

3. Set up an S3 bucket: Create an S3 bucket to store Terraform state files for each environment. Make sure to replace `<account_id>` with your AWS account ID.

### Steps:

1. Clone the repository: Clone the Terraform AWS Infrastructure repository to your local PC.

    ```bash
    git clone <repository_url>
    ```

2. Navigate to the repository directory:

    ```bash
    cd terraform-aws-infrastructure
    ```

3. Initialize Terraform: Run `terraform init` to initialize the Terraform configuration and download any necessary plugins.

    ```bash
    terraform init
    ```

4. Choose the environment: Navigate to the directory of the environment you want to deploy (e.g., `dev`, `qa`, or `prod`).

    ```bash
    cd environments/dev
    ```

5. Review Terraform plan: Run `terraform plan` to see the execution plan before making any changes. This step is optional but highly recommended.

    ```bash
    terraform plan
    ```

6. Apply Terraform changes: If the plan looks good, apply the changes using `terraform apply`. Terraform will prompt for confirmation before making any modifications to your infrastructure.

    ```bash
    terraform apply
    ```

7. Confirm changes: Review the changes Terraform intends to make and type `yes` when prompted to apply the changes.

8. Wait for completion: Wait for Terraform to provision the infrastructure. This process may take some time depending on the complexity of your configuration.

9. Verify infrastructure: Once Terraform has finished applying the changes, verify that the infrastructure has been deployed correctly by logging in to the AWS Management Console or using the AWS CLI.

10. Clean up (optional): If you want to destroy the infrastructure created by Terraform, run `terraform destroy`. This step will delete all resources managed by Terraform.

    ```bash
    terraform destroy
    ```

11. Confirm destruction: Review the list of resources to be destroyed and type `yes` when prompted to confirm the destruction.

### Notes:

- Ensure that you have appropriate permissions to create and manage AWS resources.
- Always review and validate Terraform plans before applying changes to your infrastructure.
- Make sure to replace placeholder values (such as `<repository_url>` and `<account_id>`) with actual values specific to your environment.
- Monitor the Terraform output for any errors or warnings during the execution process.
- It's recommended to maintain separate state files for each environment to avoid conflicts and maintain isolation.
- Take necessary precautions to secure sensitive information such as AWS credentials and Terraform state files.
## Deployment Pipeline with Github Actions

We've set up a deployment pipeline using GitHub Actions to automate the deployment process for each environment. In the pipeline, we need to specify the S3 bucket name, key name, DynamoDB table name, region, and the path to the backend configuration file. 

If you want to create a Key-Pair with Terraform, the commit message must contain 'key-pair'. Only then can we download the Key-Pair file from the GitHub Actions artifacts.

Configure OpenID Connect in Amazon Web Services for Github Actions. Save following values are secret in GitHub.
 -  AWS_REGION
 -  AWS_ROLE_TO_ASSUME
 -  AWS_ROLE_SESSION_NAME

Also in our pipeline we need to Navigate to the repository directory: 
    ``` 
    cd <Respective Environments>
    ```
 
eg;
  ``` 
    cd prod 
  ```

  Also we need to sepcify the branch name here
 

GitHub Actions
  ```
  on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

  ```
## Authors

- thomasvjoseph6@gmail.com
