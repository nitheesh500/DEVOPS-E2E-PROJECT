# CD process

```
GitHub (Manifest Repo)
   ↓
ARGO CD detects change
   ↓
Helm renders templates
   ↓
Kubernetes Deployment updated
   ↓
Rolling update starts[Kubernetes applies its default rollout strategy, which is: RollingUpdate]
   ↓
Prometheus observes
Grafana visualizes
```

### chart structure
```
helm/
 └── petclinic/
     ├── Chart.yaml
     ├── values.yaml
     └── templates/
         ├── namespace.yaml
         ├── deployment.yaml
         ├── service.yaml
         └── ingress.yaml
         ├── servicemonitoring.yaml
```
----
## [Repo link for cluster creation and setup ](https://github.com/nitheesh500/eks-cluster-creation.git)

1.  Make sure your [eks cluster](https://github.com/nitheesh500/eks-cluster-creation.git) is up and running   
2.  install alb by running [alb-setup.sh](https://github.com/nitheesh500/eks-cluster-creation.git)  
3. Install monitoring [monitoring-setup.sh](https://github.com/nitheesh500/eks-cluster-creation.git)

4. Install Argo CD by running [argocd-setup.sh](https://github.com/nitheesh500/eks-cluster-creation.git)


step1: apply kubectl apply for argocd-deploy.yaml file
