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

To make Terraform interact with Azure a new Azure App must be created so then those credentials can be used by the `terraform` command.

An Azure **Service Principal** is a security identity used by user-created Apps,
services, and automation tools to access specific Azure resources.

For more details visit: https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html

To generate a Service Principal (an Azure App) as a **provider** for the Terraform code,
run:

```sh
az ad sp create-for-rbac -n "Terraform-Temp" --role="Contributor" --scope="/subscriptions/${AZ_SUB_ID}"
```

The Subscription ID is stored in `~/.azure/azureProfile.json` after you login to Azure with the Azure CLI 2.0.

If you want to login to Azure via `az login` on the bash command line on Linux/Mac bash, then you can do the following (as explained on https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli):

```sh
# this pipe is to avoid printing/storing sensitive information
# on the command line history
read -p "Type the Azure username: " AZ_USER && \
  echo && \
  read -sp "Type the Azure password: " AZ_PASS && \
  echo -e "\n\n" && \
  az login -u $AZ_USER -p $AZ_PASS
```
