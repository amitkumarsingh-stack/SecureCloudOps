
# What is Azure Pipelines
Azure Pipelines is a cloud service offered by Microsoft Azure, providing a robust continuous integration and continuous deployment (CI/CD) solution. It allows teams to automatically build, test, and deploy code to various platforms and environments.

## Continuous Integration
Continuous Integration (CI) involves automating the process of validating and merging code changes into a shared repository frequently. It ensures that as new code is added, it's integrated smoothly without breaking.

## Continuous Delivery
Continuous Delivery (CD) is a process by which code is built, tested, and deployed to one or more test and production environments. Deploying and testing in multiple environments increases quality.

| Continuous Integration | Continuous Delivery |
| ------ | ------ |
| Increase code coverage | Automatically deploy code to production |
| Build faster by splitting test and build runs | Ensure deployment targets have latest code |
| Automatically ensure you don't ship broken code | Use tested code from CI process |
| Run tests continually |  |
|  |  |

## Key Concepts
![Alt text](/_Docs/Azure_DevOps_Pipelines/images/Pipeline1.png)
* A **trigger** tells a Pipeline to run.
* A **pipeline** is made up of one or more stages. A pipeline can deploy to one or more environments.
* A **stage** is a way of organizing jobs in a pipeline and each stage can have one or more jobs.
* Each **job** runs on one agent. A job can also be agentless.
* Each agent runs a job that contains one or more **steps**.
* A **step** can be a task or script and is the smallest building block of a pipeline.
* A **task** is a pre-packaged script that performs an action, such as invoking a REST API or publishing a build artifact.
* An **artifact** is a collection of files or packages published by a run.

## Azure Pipeline Terms
### Agent
An agent is like a computer setup with specific software that does one thing at a time. For example, your task might be handled on a Microsoft-owned Ubuntu computer.

### Approvals
Approvals are checks that need to happen before a deployment starts. Manual approval means someone has to give the green light before the deployment goes to the main system people use.

### Artifact
An artifact is like a bunch of files or packages created during a process. These files can be used in later steps, like sharing or installing them in different tasks.

### Continuous delivery
Continuous Delivery (CD) is a process by which code is built, tested, and deployed to one or more test and production environments. Deploying and testing in multiple environments increases quality.

### Continuous integration
Continuous Integration (CI) involves automating the process of validating and merging code changes into a shared repository frequently. It ensures that as new code is added, it's integrated smoothly without breaking.

### Deployment
In YAML pipelines, a deployment usually means a deployment job. This job is a series of steps that are done one after another in a specific setup or place.

### Deployment group
In Azure Pipelines, a Deployment Group is a way to organize multiple target machines or environments that share similar characteristics. It helps in deploying applications or configurations to a set of machines that serve a common purpose, like a group of servers in a data center or a cluster of virtual machines in the cloud. Deployment Groups make it easier to manage and automate deployments to multiple machines collectively rather than individually.

### Environment
An environment is a collection of resources, where you deploy your application. It can contain one or more virtual machines, containers, web apps, or any service that's used to host the application being developed.

### Job
A stage contains one or more jobs. Each job runs on an agent. A job represents an execution boundary of a set of steps.

For instance, imagine you have a software deployment pipeline with multiple stages: "Build," "Test," and "Deploy." Within the "Test" stage, you might have two jobs—one for running unit tests and another for conducting integration tests. Each job represents a distinct set of steps that needs to be completed within that specific testing environment.

### Pipeline
A pipeline defines the continuous integration and deployment process for your app. It's made up of one or more stages.

### Release
In Azure DevOps, a release refers to the process of deploying a software application or its components from one environment to another. It involves taking the code that has been tested and approved through various stages (such as development, testing, staging) and making it available for users in production or other target environments.

### Run
In Azure DevOps, a "run" typically refers to the execution of a pipeline, whether it's a build pipeline or a release pipeline. When you trigger a pipeline to start executing its defined tasks and stages, that instance of execution is often referred to as a "run."

### Script
A script runs code as a step in your pipeline using command line, PowerShell, or Bash.

### Stage
A stage acts as a logical division, helping organize different phases such as Build, QA, and production. Each stage can house one or more jobs, and when you have multiple stages, they typically run sequentially by default. You have the flexibility to set conditions that determine when a particular stage should run, allowing for a structured and controlled progression through the pipeline.

### Step
A step is the smallest building block of a pipeline. For example, a pipeline might consist of build and test steps. A step can either be a script or a task.

### Task
A task is the building block for defining automation in a pipeline. A task is packaged script or procedure that has been abstracted with a set of inputs.

### Trigger
A trigger is something that's set up to tell the pipeline when to run.

### Library
The Library includes secure files and variable groups. Secure files are a way to store files and share them across pipelines.

![Alt text](/_Docs/Azure_DevOps_Pipelines/images/azure-devops-pipelines-azure-devops.pdf)
