# SkylinesAcademy

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

To make Terraform interact with Azure a new Azure App must be created so then those credentials can be used by the `terraform` command.

An Azure **Service Principal** is a security identity used by user-created Apps,
services, and automation tools to access specific Azure resources.

For more details visit: https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html

To generate a Service Principal (an Azure App) as a **provider** for the Terraform code,
run:

```sh
az ad sp create-for-rbac -n "Terraform-Temp" --role="Contributor" --scope="/subscriptions/${AZ_SUB_ID}"
```

This will provide a JSON configuration object as the output that can be used later on inside your `*.tf` files.

- the `appId` will become the filed `client_id`
- the `password` will become the field `client_secret`

The Subscription ID (`${AZ_SUB_ID}` in the previous command) and the Tenant ID (later on used in the Terraform fields `subscription_id` and `tenant_id`) are stored in `~/.azure/azureProfile.json` after you login to Azure with the Azure CLI 2.0.

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

These terraform configuration/execution files are created by the `terraform` command and can be added to your `.gitignore`:

- `.terraform` (created when initializing the project)
- `terraform.tfstate` (created when applying the plan)
- `terraform.tfstate.backup` (created when destroying the plan)

# Making the code structure more robust

- The secrets like passwords and IDs should be stored in the file `terraform.tfvars`
  which should be included into the `.gitignore`
  (`echo terraform.tfvars >> .gitignore`).
- The file `main.tf` then should read the variables defined in the file `variables.tf`
  which dynamically picks whatever is defined inside the file `terraform.tfvars`.

Check the directory `Module 5` to see an example of this configuration setup.
