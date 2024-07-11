# multi-architecture-cicd

This project deploys self-hosted GitHub runners to be used for multi-architecture builds.
The implementation is reflective of a CI/CD solution we built for a mid-size security startup.

Typically, multi-architecture builds leverage an emulation tool like [QEMU](https://docs.docker.com/build/building/multi-platform/#qemu) to enable cross-platforms builds from a single machine.
This offers a simpler configuration, but delivers a significant perfomance hit when emulating another architecture.

Our solution uses the [native node strategy](https://docs.docker.com/build/building/multi-platform/#multiple-native-nodes) to give us the performance gains of native architecture builds, but still supporting multi-architecture manifests.

Going through the guide, you will notice how the `native-build` action runs almost 100% faster than the `emulated-build` action using the self-hosted runners.

## Pre-requisuites

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Helm](https://helm.sh/docs/intro/install/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Guide

1. **Generate GitHub PAT**

    Follow these [docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) to generate a PAT that the self-hosted runners will use to register with the target repository/organization.

2. **Update the variables.tf**
   
   You can update the variables.tf with the config url and pat or create a .tfvars file

    ```hcl
      variable "github_config" {
        type = object({
          config_url = string
          pat = string
        })
        default = {
        config_url = "https://github.com/${organization}/${repo}"
        pat = "${github_pat}"
      }
    }
    ```
3. **Initialize AZ CLI**

run the following commands to initialize your az cli

```sh
az cloud set --name AzureCloud
az login
az account set --subscription ${subscription}
```

4. **Deploy Cluster**

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

5. **Create a PR to validate pipelines**

Update the `REGISTRY` value to match your ghcr repository, push your changes, and create a Pull Request.
This will trigger the `emulated-build` and `native-build` to kickoff.

## Tooling Docs

* [AKS](https://learn.microsoft.com/en-us/azure/aks/)
* [Terraform](https://github.com/stretchr/testify)
* [GitHub Runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/deploying-runner-scale-sets-with-actions-runner-controller)
* [GitHub Actions](https://docs.github.com/en/actions)