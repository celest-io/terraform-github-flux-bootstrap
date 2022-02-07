terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
    }
    github = {
      source = "integrations/github"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
  required_version = ">= 1.0"
}

