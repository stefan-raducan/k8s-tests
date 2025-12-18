resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.51.6"

  set = [
    {
      name  = "server.service.type"
      value = "NodePort"
    },
    {
      name  = "server.service.nodePortHttps"
      value = "30443"
    },
    {
      name  = "redis-ha.enabled"
      value = "false"
    },
    # {
    #   name  = "controller.replicas"
    #   value = "1"
    # },
    # {
    #   name  = "server.replicas"
    #   value = "1"
    # },
    # {
    #   name  = "repoServer.replicas"
    #   value = "1"
    # },
    # {
    #   name  = "applicationSet.replicas"
    #   value = "1"
    # }

  ]

  depends_on = [kubernetes_namespace.argocd]
}

resource "kubernetes_manifest" "app_of_apps" {
  manifest = yamldecode(file("${path.module}/../argocd/bootstrap/dev-test-cluster.yaml"))

  depends_on = [helm_release.argocd]
}
