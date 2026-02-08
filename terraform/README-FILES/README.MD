# Spring PetClinic – Real-Time DevOps Implementation 🚀

This repository demonstrates a **real-world, end-to-end DevOps implementation** using the **Spring PetClinic** application as the base project.

The goal is to design and implement an **industry-grade CI/CD pipeline with GitOps and Monitoring**, closely matching how production DevOps teams work.

---

## 🏗️ Architecture Overview

```text
Developer
   |
   v
GitHub (Application Repository)
   |
   v
Jenkins (CI Pipeline)
   ├── Maven Build
   ├── SonarQube Code Analysis
   ├── Docker Image Build
   ├── Trivy Image Security Scan
   ├── Push Image to Container Registry
   └── Update Kubernetes Manifest Repository
            |
            v
        Argo CD (GitOps CD)
            |
            v
        Amazon EKS Cluster
            ├── Spring PetClinic Application
            └── Prometheus + Grafana (Monitoring)a
```


---

## 🧰 Tech Stack

### Application
- Java 17
- Spring Boot (Monolithic)
- Maven
- Spring Boot Actuator

### CI/CD
- Jenkins
- GitHub
- Docker
- Trivy
- SonarQube (Community Edition)

### GitOps & Platform
- Kubernetes (EKS)
- Argo CD
- Helm
- kubectl
- eksctl
- AWS CLI

### Monitoring
- Prometheus
- Grafana

---


> Kubernetes manifests are maintained in a **separate GitOps repository**.

---

## ✅ Implemented DevOps Stages

### 1️⃣ Local Development
- Build using Maven
- Run Spring Boot application
- Verify UI and actuator endpoints

### 2️⃣ Application Readiness
- Spring Boot Actuator enabled
- Health and Prometheus endpoints exposed

Endpoints:
- `/actuator/health`
- `/actuator/metrics`
- `/actuator/prometheus`

---

### 3️⃣ Containerization
- Multi-stage Docker build
- Java 17 runtime
- Non-root container user
- Optimized image layers

---

### 4️⃣ CI Pipeline (Jenkins)
- Source checkout
- Maven build (skip integration tests)
- SonarQube static code analysis
- Quality gate enforcement
- Docker image build
- Trivy vulnerability scan
- Push image to container registry
- Update Kubernetes manifest repository

---

### 5️⃣ GitOps CD
- Argo CD monitors manifest repository
- Automatic sync and deployment to EKS
- No `kubectl` usage from Jenkins

---

### 6️⃣ Monitoring & Observability
- Spring Boot metrics exposed via Actuator
- Prometheus scrapes application metrics
- Grafana dashboards for JVM and app metrics

---

## 🖥️ Jenkins Node Setup

Installed tools:
- Docker
- Jenkins
- Java 17 (Amazon Corretto)
- Git
- Maven
- Trivy
- AWS CLI
- kubectl
- eksctl
- Helm

SonarQube runs as:
- Docker container
- Backed by PostgreSQL
- Accessible on port `9000`

---

## 🔐 Security & Best Practices

- Non-root Docker containers
- Secrets managed via Jenkins Credentials
- Image vulnerability scanning with Trivy
- Quality gates enforced via SonarQube
- GitOps for controlled deployments

---

## 📝 License

This project is for **learning and demonstration purposes**.
Base application is from the official Spring PetClinic project.

