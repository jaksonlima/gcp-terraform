#!/usr/bin/env bash
# cert-manager com Gateway API (gateway-shim).
# Pré-requisito: CRDs da Gateway API no cluster, por exemplo:
#   kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml
#
# kubectl: precisa do plugin gke-gcloud-auth-plugin (ver cluster/commands/01.md).

set -euo pipefail

helm repo add jetstack https://charts.jetstack.io --force-update
helm repo update

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.20.1 \
  --set crds.enabled=true \
  --set config.apiVersion=controller.config.cert-manager.io/v1alpha1 \
  --set config.kind=ControllerConfiguration \
  --set config.enableGatewayAPI=true

kubectl rollout status deployment/cert-manager -n cert-manager --timeout=120s
echo "OK: ver gateway-shim com: kubectl logs -n cert-manager deploy/cert-manager | grep -i gateway"
