locals {
  target_path = "clusters/${var.environment}/${var.cluster_name}"
  key_name    = "flux-${var.environment}-${var.cluster_name}"
}

data "github_repository" "flux" {
  full_name = "${var.github_owner}/${var.repository_name}"
}

data "flux_install" "main" {
  target_path    = local.target_path
  cluster_domain = var.cluster_domain
  namespace      = var.namespace
}

data "flux_sync" "main" {
  namespace   = var.namespace
  target_path = local.target_path
  url         = "ssh://git@github.com/${data.github_repository.flux.full_name}.git"
  patch_names = keys(var.patches)
}

resource "tls_private_key" "main" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name   = data.flux_sync.main.namespace
    labels = var.namespace_labels
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = var.known_hosts
  }
}

resource "github_repository_deploy_key" "main" {
  title      = local.key_name
  repository = data.github_repository.flux.name
  key        = tls_private_key.main.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  repository = data.github_repository.flux.name
  file       = data.flux_install.main.path
  content    = data.flux_install.main.content
  branch     = var.branch
}

resource "github_repository_file" "sync" {
  repository = data.github_repository.flux.name
  file       = data.flux_sync.main.path
  content    = data.flux_sync.main.content
  branch     = var.branch
}

resource "github_repository_file" "kustomize" {
  repository = data.github_repository.flux.name
  file       = data.flux_sync.main.kustomize_path
  content    = data.flux_sync.main.kustomize_content
  branch     = var.branch
}

resource "github_repository_file" "patches" {
  for_each   = data.flux_sync.main.patch_file_paths
  repository = data.github_repository.flux.name
  file       = each.value
  content    = var.patches[each.key]
  branch     = var.branch
}
