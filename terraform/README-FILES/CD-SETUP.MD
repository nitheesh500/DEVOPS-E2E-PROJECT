# CD process

```
Jenkins (CI)
  → builds & pushes image
  → updates Helm values.yaml (image tag)

Git (Manifest Repo)
  → Helm chart (petclinic)
  → values.yaml updated

Argo CD
  → syncs Helm chart
  → deploys to EKS

Users
  → Ingress (Helm-managed)
```

### chart structure
```
helm/
 └── petclinic/
     ├── Chart.yaml
     ├── values.yaml
     └── templates/
         ├── deployment.yaml
         ├── service.yaml
         └── ingress.yaml
```