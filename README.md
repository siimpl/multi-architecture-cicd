# multi-architecture-cicd

This project deploys self-hosted GitHub runners to be used for multi-architecture builds and offers up to **90% faster builds**.
The implementation is reflective of a CI/CD solution we built for a mid-size security startup.

Typically, multi-architecture builds leverage an emulation tool like [QEMU](https://docs.docker.com/build/building/multi-platform/#qemu) to enable cross-platforms builds from a single machine.
This offers a simpler configuration, but delivers a significant perfomance hit when emulating another architecture.

Our solution uses the [native node strategy](https://docs.docker.com/build/building/multi-platform/#multiple-native-nodes) to give us the performance gains of native architecture builds, but still supporting multi-architecture manifests.

Going through the guide, you will notice how the `native-build` action (self-hosted runners) runs roughly 90% faster than the `emulated-build` action (github-hosted runners), and roughly 95% faster leveraging [Docker Build Cloud](https://www.docker.com/products/build-cloud/)

## Business Impact

Improving build times has a direct impact on [DORA metrics](https://dora.dev/quickcheck/). Primarily on the `Lead time for changes` and `Time to restore`, but has an impact on all metrics. If this use-case fits your purposes, the drop in build times could have a significant impact on your teams DORA report.

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

## Docker Build Cloud

This is a new feature set that offers blazing fast builds, multi-architecture support, shared build caching right from the Docker Desktop app.

Setup is straightforward, and can be done following this guide: [DBC setup guide](https://docs.docker.com/build-cloud/setup/). Once you've done this, you will be able to target remote builders for local development builds. This is hugely beneficial for heavier/multi-architecture builds, since you can leverage the speed of native-arch builders for local development!

Following this guide, you can integrate these builders into your CI/CD pipelines: [CI/CD integration guide](https://docs.docker.com/build-cloud/ci/). Also, see the `docker-build-cloud.yml` for the working example for this project.

## Tooling Docs

* [AKS](https://learn.microsoft.com/en-us/azure/aks/)
* [Terraform](https://github.com/stretchr/testify)
* [GitHub Runners](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/deploying-runner-scale-sets-with-actions-runner-controller)
* [GitHub Actions](https://docs.github.com/en/actions)
* [Docker Build Cloud](https://www.docker.com/products/build-cloud/)
