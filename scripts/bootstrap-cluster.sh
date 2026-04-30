#!/usr/bin/env bash
# Yeni bir cluster acildiktan sonra ihtiyac duyulan baseline addon'lari kurar.
set -euo pipefail

CLUSTER_NAME="${1:-k8s-staging}"
REGION="${2:-eu-west-1}"

echo ">>> kubeconfig set"
aws eks update-kubeconfig --name "$CLUSTER_NAME" --region "$REGION"

echo ">>> metrics-server"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo ">>> argocd namespace + install"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.10.0/manifests/install.yaml

echo ">>> root app"
kubectl apply -f argocd/root-app.yaml

echo "Done. ArgoCD admin sifresi:"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo
