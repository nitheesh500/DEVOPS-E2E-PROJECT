```
Make sure PetClinic app is healthy

STEP 1 → Install Prometheus + Grafana (Helm)
STEP 2 → Access Grafana UI
STEP 3 → Verify Prometheus is scraping Kubernetes
STEP 4 → Expose Spring Boot metrics
STEP 5 → Visualize app metrics in Grafana
```

perform  step 1,2,3,5 only. step 4 is added.
---
## 🟢 STEP 1: INSTALL PROMETHEUS + GRAFANA
### 1.1 Add Helm repo
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 1.2 Create monitoring namespace
```
kubectl create namespace monitoring
```

### 1.3 Install Prometheus + Grafana
```
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

  helm upgrade monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

```

⏳ Wait ~2 minutes.

### 1.4 Verify pods
```
kubectl get pods -n monitoring
```
---


## 🟢 STEP 2: ACCESS GRAFANA

### 2.1 Expose Grafana (LAB WAY)
```
kubectl patch svc monitoring-grafana -n monitoring \
  -p '{"spec": {"type": "LoadBalncer"}}'
```

### 2.2 Get loadbalancer url
```
kubectl get svc monitoring-grafana -n monitoring
```

### 2.3 Get admin password
```
kubectl get secret monitoring-grafana -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 --decode
```

### 2.4 Login
```
http://load-balacer
user: admin
password: <decoded>
```

### ✅ CHECKPOINT 1 (DO NOT SKIP)

In Grafana:
```
Go to Dashboards

Open:

Kubernetes / Compute Resources / Node
```

If you see CPU & memory graphs →  
✅ Prometheus + Grafana are working

---

### 🟢 STEP 3: QUERY PETCLINIC METRICS

In Prometheus UI, run:
```
http_server_requests_seconds_count
```

You should see time series data 🎉


### 🟩 STEP 4: VIEW METRICS IN GRAFANA (REAL PAYOFF)
### 4.1 Import Spring Boot Dashboard

In Grafana:  

1. Dashboards → Import
2. Import ID: 4701
3. Select datasource: Prometheus
4. Click Import

### 4.2 What You Should See
```
JVM memory
Heap usage
GC activity
HTTP request count
Response latency
```