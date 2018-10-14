# SkylinesAcademy

This is the code and documentation for the MOOC on Udemy with title: *"Getting Started with Terraform for Azure"*.

## Terraform installation

On Linux/Mac using bash:

```sh
mkdir ~/tmp/
wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip -P ~/tmp/
sudo unzip ~/tmp/terraform_0.11.8_linux_amd64.zip -d /usr/local/bin/
```

This will install Terraform on `/usr/local/bin` which is usually included in the `$PATH` environment variable,
so the command `terraform` can be invoked from anywhere in the file system.

## Terraform authentication to Azure

First of all you need to login to Azure via the command line (Azure CLI 2.0, `az login`).

On the bash command line on Linux/Mac you can do the following (as explained on https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli):

```sh
# this pipe is to avoid printing/storing sensitive information
# on the command line history
read -p "Type the Azure username: " AZ_USER && \
  echo && \
  read -sp "Type the Azure password: " AZ_PASS && \
  echo -e "\n\n" && \
  az login -u $AZ_USER -p $AZ_PASS
```

To make Terraform interact with Azure a new Azure App must be created so then those credentials can be used by the `terraform` command. An Azure **Service Principal** is a security identity used by user-created Apps,
services, and automation tools to access specific Azure resources. For more details visit: https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html

To generate a Service Principal (an Azure App) as a **provider** for the Terraform code,
run the following command with the Azure CLI 2.0:

```sh
az ad sp create-for-rbac -n "Terraform-Temp" --role="Contributor" --scope="/subscriptions/${AZ_SUB_ID}"
```

This will provide a JSON configuration object as the output that can be used later on inside your `*.tf` files.

- the `appId` will become the Terraform filed `client_id`
- the `password` will become the Terraform field `client_secret`
- the Subscription ID (`${AZ_SUB_ID}` in the previous command) will become the Terraform field `subscription_id`, it is stored in `~/.azure/azureProfile.json` after you login to Azure with the Azure CLI 2.0
- the Tenant ID can be found in the JSON output object of the previous command or in `~/.azure/azureProfile.json`, it will become the Terraform field `tenant_id`

# Terraform Constructs and Execution

Take the `main.tf` file in the `Module 4` directory:

- A **provider** is responsible for understanding API interactions and exposing resources on your targets (e.g. Azure, Vmware, AWS, Github, Gitlab etc.), c.f.:
  https://www.terraform.io/docs/providers/index.html
- The **resources** are where we define the objects that we create on our environment:
  - component e.g. resource
  - provider e.g. Azure Resource Manager
  - type e.g. Resource Group
  - name is the label used through out the code to identify this object
- When resources are initially created, **provisioners** can be executed to initialize those resources.

## Terraform Execution

The `terraform` commands (targeting the current directory containing the `*.tf` files) have the following lifecycle:

1. **Init**: in case some plugins need to be downloaded (`terraform init`,
   this will create a directory called `.terraform`)
2. **Plan**: to make sure the code works as expected (`terraform plan`,
   this will show some information about the resources that are going to be
   **added, changed or destroyed** on Azure)
2. **Execute**: to implement the rules in the code regarding the resource
   on Azure (`terraform execute`, you need to type `yes` when asked for)
3. **Destroy**: to destroy all the resources defined in the code
   (`terraform destroy`, you need to type `yes` when asked for)

The following configuration/execution files are created by the `terraform` command and can be added to your `.gitignore` to avoid including them in the versioned code base with git:

- `.terraform` (created when initializing the project)
- `terraform.tfstate` (created when applying the plan)
- `terraform.tfstate.backup` (created when destroying the plan)

# Making the code structure more robust

- The secrets like passwords and IDs should be stored in the file `terraform.tfvars`
  which should not be included in your git repository, it could be added to the `.gitignore` file to be ignored
  (on Linux/Max bash: `echo terraform.tfvars >> .gitignore`).
- The file `main.tf` then should read the variables defined in the file `variables.tf`
  which dynamically picks whatever is defined inside the file `terraform.tfvars`.

Check the directory `Module 5` to see an example of this configuration setup.

# Deploy a Virtual Machine in Azure with Terraform

To define a virtual machine (VM) go to https://www.terraform.io/, then click on:
- Docs (top right bar)
- Providers (left side panel)
- Azure (table in the main section)
- Compute Resources / `azure_virtual_machine` (left side panel, then landing here: https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html)

# Terraform Modules

Terraform **modules** are used to factor out functionality into a sub-directory,
that **can be referenced from somewhere else** and reused multiple times.
Take as an example the `main.tf` file in the directory `Module 7` providing the
file system path to the sub-directory where the Terraform module is defined.

Check the documentation here:

- https://www.terraform.io/intro/getting-started/modules.html
- https://www.terraform.io/docs/modules/index.html
- https://www.terraform.io/docs/modules/create.html

Modules can be shared with the Terraform community on: https://registry.terraform.io/

The directory `Module 7b` is an usage example of the "compute" module.
Make sure you have the **Azure CLI 2.0** installed, otherwise this
module will give errors i.e. run `az login` to login as a first step.

# Terraform graph

To **see all the resources and the mappings between them** as defined in your Terraform files you can use
the command: `terraform graph`.
