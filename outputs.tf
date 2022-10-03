output "namespace" {
  description = "Flux Kubernetes namespace"
  value       = data.flux_sync.main.namespace
}
