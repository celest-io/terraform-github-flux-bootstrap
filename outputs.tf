output "namespace" {
  description = "Flux Kubernetes namespace"
  value       = data.flux_sync.main.namespace
}

output "github_key" {
  description = "The GitHub public ssh key"
  value       = tls_private_key.main.public_key_openssh
}
