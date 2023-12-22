
# Terraform Pipeline

## Prerequisite to run the Pipeline
To run this Terraform pipeline successfully, ensure you have:

* __Azure DevOps Account__: Access to Azure DevOps with appropriate permissions to create and manage pipelines.
* __Azure Subscription__: An active Azure subscription to create and manage resources.
* __Service Connection__: Set up an Azure service connection in Azure DevOps to interact with Azure resources.
* __Azure Storage Account__: Create an Azure Storage Account and set up the necessary containers for storing Terraform state files.
* __Azure Resource Group__: Pre-create the Azure Resource Groups where Terraform will manage resources.
* __Terraform Configuration__: Have valid Terraform configuration files (.tf) for the resources you want to manage. Ensure they are structured and error-free.
* __Variable Files__: Prepare the necessary Terraform variable files (.tfvars) for different environments (prod.tfvars, dev.tfvars, staging.tfvars) as per the pipeline setup.
* __Artifact Naming__: Review and set appropriate artifact names (AM in this case) and file patterns for artifacts in the pipeline.


## Pipeline Trigger Condition
This pipeline is triggered on changes to the following branches:
* 'main'
* 'dev'
* 'staging'

## Parameters
* __envName__: Select the environment for deployment. Choose from NonProd, Prod, or Staging.
* __actionToPerform__: Choose between Deploy or Destroy. The default value is Deploy.

## Variables
* __getTfVars__: Specifies the Terraform variable file based on the source branch.
* __runDestroy__: Controls whether to execute the Terraform destroy. Default is set to false.
* __ServiceConnection__: Azure DevOps service connection name.
* __resourceGroup__: Azure Resource Group name.
* __storageAccount__: Azure Storage Account name.
* __storageAccountSku__: Azure Storage Account SKU.
* __container__: Azure Storage Container name.
* __tfstateFile__: Azure Storage Blob containing the Terraform state file.
* __BuildAgent__: Build agent image to be used.
* __terraform_ver__: Terraform version to be installed.
* __workingDir__: Working directory for Terraform commands.
* __target__: Target directory for publishing artifacts.
* __artifact__: Artifact name.

## Build Agents
The pipeline uses the specified Build Agent image for the build stages.

## Stages
### PUBLISH_PLAN
* __Install Terraform__: Installs the specified Terraform version.
* __Terraform Init__: Initializes Terraform with the Azure Storage Backend.
* __Terraform Validate__: Validates the Terraform configuration.
* __Terraform Plan__: Generates a Terraform plan and publishes it as an artifact.

## BUILD
* __Install Terraform__: Installs the specified Terraform version.
* __Terraform Init__: Initializes Terraform with the Azure Storage Backend.
* __Terraform Validate__: Validates the Terraform configuration.
* __Terraform Plan: Generates a Terraform plan.
* __Copy Files to Artifacts Staging Directory__: Copies Terraform files and plans to the staging directory.
* __Publish Artifacts__: Publishes Terraform artifacts.

## DEPLOY
* __Download Artifacts__: Downloads Terraform artifacts.
* __Install Terraform__: Installs the specified Terraform version.
* __Terraform Init__: Initializes Terraform with the Azure Storage Backend.
* __Terraform Apply__: Applies Terraform changes.

## Destroy
* __Download Artifacts__: Downloads Terraform artifacts.
* __Install Terraform__: Installs the specified Terraform version.
* __Terraform Init__: Initializes Terraform with the Azure Storage Backend.
* __Terraform Destroy__: Destroys Terraform resources based on the specified variables and configuration.

## Manual Approval Gates
### Deployment Stage
Before deploying changes to the environment, this pipeline includes a manual approval gate. Once the deployment steps are completed, the pipeline pauses and waits for manual approval from designated reviewers.

### Destruction Stage
Similarly, before executing the destruction stage, the pipeline includes a manual approval gate to ensure careful consideration before removing resources.

__Note__: The Destroy stage is conditional and will only run if __runDestroy__ is set to __true__.