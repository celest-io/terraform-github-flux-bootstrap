# Terraform GitHub Flux Bootstrap

[![GitHub Release](https://img.shields.io/github/release/celest-io/terraform-github-flux-bootstrap.svg?style=flat)]()

A terraform module that will bootstrap FluxCD (v2) on a Kubernetes cluster using a GitHub provider

## Usage

Below are few examples on how to use this module

#### Simple

```terraform
module "flux" {
  source          = "celest-io/flux-bootstrap/github"
  github_owner    = "celest-io"
  repository_name = "kubernetes"
  target_path     = "cluster/dev/my-cluster"
  key_name        = "dev-my-cluster"
}
```
