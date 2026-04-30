# devops-k8s-stack

Production-grade Kubernetes platformu kurmak için iskelet repo. AWS EKS üzerinde Terraform ile cluster, Helm chart ile uygulama deploy, ArgoCD ile GitOps, Prometheus + Grafana ile observability, GitHub Actions ile CI/CD pipeline'ı içerir.

## İçerik

```
terraform/          → AWS EKS, VPC, IAM, EBS CSI driver
helm/api/           → Örnek uygulama Helm chart'ı
argocd/             → ArgoCD root app + uygulama tanımları
monitoring/         → kube-prometheus-stack helm values
ansible/            → bastion host hazırlama playbook
docker/             → multi-stage Dockerfile örnekleri
.github/workflows/  → build, scan, deploy pipeline
scripts/            → yardımcı bash script'ler
docs/               → mimari + runbook
```

## Özellikler

- **Terraform** ile EKS 1.29 cluster (3 AZ, t3.large node group, autoscaler)
- **VPC**: public + private subnet, NAT GW, S3 endpoint
- **IRSA** ile pod-level IAM (cluster-autoscaler, external-dns, aws-load-balancer-controller)
- **Helm chart** + `values-staging.yaml` / `values-prod.yaml`
- **ArgoCD** app-of-apps pattern (sync wave, self-heal)
- **Prometheus + Grafana** (kube-prometheus-stack) + örnek alert rule
- **GitHub Actions**: PR'da build + Trivy SAST/SCA, main'de image push + GitOps update
- **Ansible** ile bastion host bootstrap (system hardening + tools)

## Hızlı bakış

```bash
# 1) Cluster'ı ayağa kaldır
cd terraform/envs/staging
terraform init
terraform apply

# 2) ArgoCD ve root app'i kur
kubectl apply -f argocd/install.yaml
kubectl apply -f argocd/root-app.yaml

# 3) Monitoring
helm upgrade --install kps prometheus-community/kube-prometheus-stack \
  -f monitoring/values.yaml -n monitoring --create-namespace
```

## Pipeline akışı

```
PR  → lint + unit test + Trivy scan + helm template diff
main → image build → ECR push → GitOps repo'ya tag bump → ArgoCD sync
```

## Notlar

Repodaki çoğu modül "production-ready iskelet" kıvamında: gerçek hesabınıza adapte etmek için `terraform.tfvars` ve `values.yaml` dosyalarını projenize göre düzenleyin. AWS hesabı + IAM credentials gerekir.

## Lisans

MIT
