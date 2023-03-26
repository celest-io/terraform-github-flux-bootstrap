terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.25"
    }
    github = {
      source  = "integrations/github"
      version = ">= 5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.18"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.0"
}
