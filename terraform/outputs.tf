output "helm_hostname" {
  description = "The hostname for accessing services deployed via Helm."
  value       = helm_release.argocd.metadata.name
}
