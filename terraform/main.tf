resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubernetes_namespace" "cloudflared" {
  metadata {
    name = "cloudflared"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubernetes_namespace" "github-runner" {
  metadata {
    name = "github-runner"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
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

# kubectl create secret generic github-runner-secret \
#   --from-literal=github_token=ARC_RUNNER_SPECIFIC_PAT \
#   -n github-runner --dry-run=client -o yaml | kubectl apply -f -

# https://one.dash.cloudflare.com/f431007b7221f1fbf07048122d56c7c2/networks/connectors/cloudflare-tunnels/cfd_tunnel/70fff944-db91-450f-a6d2-f545b9173b89/edit?tab=overview
# kubectl create secret generic tunnel-credentials \
#   --from-literal=token='TOKEN' \
#   -n cloudflared

# at the end of the terraform apply and secret creation run the following to enable argocd management:
# kubectl apply -f argocd/bootstrap/dev-test-cluster.yaml
