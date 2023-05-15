# Python Docker App deployed by Github Actions to AWS

## Initiate a docker based python APP development environment

```
clone repository && cd into it
create .gitignore
create .dockerignore
python -m venv .venv
WIN .\.venv\Scripts\activate
LNX source venv/bin/activate
# pip install . 
# pip install argparse
# pip install python-dotenv 
# pip install diagrams or you can use requirements.txt
pip install -r requirements.txt 
# pip freeze -l > requirements.txt 
.env
    for Powershell:
        $env:VARIABLE="PARAMETER"

    for windows cmd:
        set VARIABLE=PARAMETER

    or add to launch.json for vsvode debugging - in the configurations section
        "envFile": "${workspaceFolder}/.env",
        and add
        VARIABLE="PARAMETER",
        to .env in the root folder of your project

    or add to launch.json for vscode debugging - in the configurations section
        "env" : {"VARIABLE" : "PARAMETER"},

# python change_me.py --debug run

```

## Setup Python project using Docker

- Basic project setup to use in our Docker container (app folder)
- Dockerfile

## Build our Docker Container and Run

```
sudo docker build --no-cache -t change_me:v1.0 .
docker run --name change_me -it -d change_me:v1.0
docker exec -it change_me /bin/bash
docker container inspect change_me
```

## Core components

### AWS

The AWS infrastructure is setup using terraform in the [`./terraform`](./terraform).

The following components are deployed:

- Application Load Balancer ([`./lb.tf`](./terraform/lb.tf))
- ECS Cluster / ECS Service ([`./ecs.tf`](./terraform/ecs.tf))
- Elastic Container Registry ([`./ecr.tf`](./terraform/ecr.tf))
- IAM permissions ([`./iam.tf`](./terraform/iam.tf))
- VPC configuration ([`./vpc.tf`](./terraform/vpc.tf))

### CI/CD

The repository leverages the [AWS Github Actions](https://github.com/aws-actions/)
maintained by AWS.

The main goal is to provide an example configuration of the following workflow:

- Run the integration tests
- Build the Docker image
- Publish it to a private ECR
- Update the corresponding ECS Service (by editing the task image)

## Runbook
- Set up the AWS credentials: Create an IAM user in your AWS account with the necessary permissions to manage ECS resources. Obtain the access key and secret key for this IAM user.

- Configure Terraform: Install Terraform on your local machine and set up the necessary configuration files. Create a new Terraform module or use an existing one for ECS deployment.

- Write Terraform scripts: In your Terraform module, define the resources required for ECS deployment. This includes ECS clusters, task definitions, services, load balancers, etc. Make sure to specify the container image, ports, environment variables, and any other relevant configuration.

- Create infrastructure as code: Create Terraform configuration files (.tf) to define your desired infrastructure state. Declare variables for configurable values like AWS region, container image, and environment variables. Define the ECS resources using Terraform resource blocks.

- Set up GitHub Actions: Create a GitHub repository for your project and navigate to the "Actions" tab. Create a new workflow file (e.g., .github/workflows/ecs-deploy.yml) to define the deployment process.

- Configure GitHub Actions workflow: In the workflow file, define the necessary steps to deploy the container. This typically involves checking out the repository, configuring AWS credentials, running terraform init and terraform apply commands, and handling any required input variables.

- Store secrets: Store sensitive information like AWS access key and secret key as GitHub repository secrets. You can access these secrets in your workflow file as environment variables to authenticate with AWS.

- Commit and push changes: Commit your Terraform scripts, GitHub Actions workflow file, and any other necessary changes to your repository. Push them to the remote repository, triggering the GitHub Actions workflow.

- Monitor deployment: Monitor the GitHub Actions workflow execution for any errors or issues. You can view the deployment progress, logs, and any failure messages in the GitHub Actions console.

## Bonus — Makefile

Let’s create a simple Makefile that allows us to build, run, and kill our image/container:

```
app_name = change_me
build:
    @docker build -t $(app_name) .
run:
    docker run -d -p 8000:8000 $(app_name)
kill:
    @echo 'Killing container...'
    @docker ps | grep $(app_name) | awk '{print $1}' | xargs docker stop
```

Now we should be able to run:

```
# build Docker image
make build
# run the container
make run
# destroy it
make kill
```

## Create a python test environment from scratch

do the above steps to create a virtual environment:

```
mkdir test
```

test_hello.py

```
def test_failing():
    assert True == True
```

pytest
