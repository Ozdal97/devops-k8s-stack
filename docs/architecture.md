# Mimari

```
              ┌──────────────┐
   GitHub ───▶│ Actions (CI) │──▶ ECR
              └──────────────┘
                     │
                     ▼ (values bump)
              ┌──────────────┐       ┌────────────┐
              │  Git (main)  │◀──────│  ArgoCD    │
              └──────────────┘       └─────┬──────┘
                                           │ sync
                                           ▼
                                   ┌────────────────┐
                                   │  EKS Cluster   │
                                   │  (3 AZ)        │
                                   └─────┬──────────┘
                                         │
                       ┌─────────────────┼─────────────────┐
                       ▼                 ▼                 ▼
                 ┌──────────┐      ┌──────────┐      ┌──────────────┐
                 │  api     │      │  worker  │      │  monitoring  │
                 │ (HPA)    │      │ (queue)  │      │ Prom+Grafana │
                 └──────────┘      └──────────┘      └──────────────┘
```

## Kararlar (ADR özet)

- **GitOps**: ArgoCD app-of-apps. Image tag bump CI tarafında, manifest değişiklikleri PR ile.
- **State**: Terraform state S3 + DynamoDB lock. Workspaces yerine ayrı `envs/` dizini.
- **Networking**: Private subnet'lere worker node, public subnet'e ALB. NAT GW her AZ'de ayrı.
- **Observability**: kube-prometheus-stack tek paket; uygulama metrikleri ServiceMonitor üzerinden.
