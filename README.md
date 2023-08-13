# TERRAFORM JUMP START
## Initial Setup

### [Terraform (1.2.0+) CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 

> **terraform -help**

### [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

> **aws --version**

### [Configure AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) 
> **aws configure**

        C:\Users\hites>aws configure
        AWS Access Key ID [****************E3HG]:
        AWS Secret Access Key [****************i45r]:
        Default region name [None]:
        Default output format [None]:



### [Install Docker Desktop](https://docs.docker.com/desktop/install/windows-install/)
> **docker --help**

#### [Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
> **wsl --install**

----
# RUNNING THE PROJECT

Open Command Terminal and navigate into docker or aws package and follow  the steps below:


 
## 1. Find & Initialize the Provider Plugin
 > terraform **init**

After changing configuration upgrade Providers
 > terraform **init -upgrade**

## 2. Provision Infrastructure

See any changes that are required for your infrastructure. All Terraform commands
should now work.

> terraform **plan**

Create the Infrastructure
> terraform **apply**

## 3. Destroy the Infrastructure

Commnet out resource you want to destroy and run apply OR run

 > terraform **destroy**

 ----
 





