variable "github_owner" {
  description = "Github owner"
  type        = string
}

variable "repository_name" {
  description = "Github repository name"
  type        = string
}

variable "branch" {
  description = "Branch name"
  type        = string
  default     = "main"
}

variable "sync_interval" {
  description = "Sync interval in minutes."
  type        = number
  default     = 1
}

variable "namespace" {
  description = "The namespace on which Flux will be installed."
  type        = string
  default     = "flux-system"
}

variable "namespace_labels" {
  description = "Kubernetes labels to be applied on the flux namespace."
  type        = map(string)
  default     = {}
}

variable "target_path" {
  description = "Relative path to the Git repository root where Flux manifests are committed."
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key"
  type        = string
}

variable "cluster_domain" {
  description = "The internal cluster domain."
  type        = string
  default     = "cluster.local"
}

variable "image_pull_secrets" {
  description = "Kubernetes secret name used for pulling the toolkit images from a private registry."
  type        = string
  default     = ""
}

variable "patches" {
  description = "The patches to be added to the flux kustomize manifest."
  type        = map(string)
  default     = {}
}

variable "known_hosts" {
  type    = string
  default = "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
}
