# GitHub Runner ArgoCD Application

This application manages the deployment of self-hosted GitHub Actions runners within the Kubernetes cluster using ArgoCD.

## Overview

Deploys and manages the lifecycle of a GitHub runner.

## Prerequisites

- ArgoCD installed in the cluster.
- GitHub Personal Access Token (PAT) or GitHub App credentials stored as a Kubernetes Secret.
- Namespace `github-runner` created (or handled by ArgoCD sync options).

## Structure

- `application.yaml`: The ArgoCD Application manifest.
- `values.yaml`: Configuration values for the underlying Helm chart or manifests.
- `templates/`: Resource templates if using a local chart.

## Deployment

To deploy this application manually:

```bash
kubectl apply -f application.yaml
```

Alternatively, add this path to your ArgoCD "App of Apps" root manifest.

## Configuration

Key configurations available in `values.yaml`:

| Parameter | Description |
|-----------|-------------|
| `githubOwner` | The GitHub organization or user owning the runners. |
| `runnerImage` | The container image used for the runner. |
| `minReplicas` | Minimum number of idle runners. |
| `maxReplicas` | Maximum number of scaled runners. |

## Sync Policy

This application is configured with `automated` sync policy by default. Ensure any manual changes to the cluster are reconciled through the Git repository to avoid configuration drift.
