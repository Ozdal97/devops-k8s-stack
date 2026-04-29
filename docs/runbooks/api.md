# API runbook

## High error rate (ApiHighErrorRate)

1. Grafana > "API Overview" panelinde son 30 dk error rate'i incele.
2. `kubectl -n api-staging logs -l app.kubernetes.io/name=api --tail=200`
3. Son deploy edilen image tag'ini kontrol et:
   `kubectl -n api-staging get deploy -o jsonpath='{.items[0].spec.template.spec.containers[0].image}'`
4. Gerekirse rollback:
   `kubectl -n api-staging rollout undo deploy/api`
5. Persist eden bir hata varsa ArgoCD'den önceki revision'a sync et.

## High latency (ApiHighLatency)

1. Postgres slow query log + RDS performance insights kontrol.
2. Redis hit ratio: `redis-cli info stats | grep keyspace`
3. HPA aktivitesi: `kubectl -n api-staging get hpa`

## Cluster autoscaler bekliyor

1. `kubectl -n kube-system logs deploy/cluster-autoscaler --tail=200`
2. Pending pod sebebi (`kubectl describe pod ...`) — genelde ya CPU ya memory request fazla.
