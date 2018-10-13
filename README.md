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
