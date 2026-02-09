# CI Pipeline – Jenkins Setup (Spring PetClinic)

This document describes the **Continuous Integration (CI)** setup implemented using **Jenkins** for the Spring PetClinic application.

The CI pipeline follows **industry best practices**:
- Pipeline as Code (Jenkinsfile)
- Secure credentials handling
- Code quality enforcement
- Container security scanning

---

---

## 🛠 Tools Used

| Tool | Purpose |
|----|----|
| Jenkins | CI orchestration |
| Maven | Build & unit testing |
| SonarQube | Static code analysis |
| Docker | Containerization |
| Trivy | Container vulnerability scanning |
| GitHub | Source control |

---

## 🔐 Prerequisites

Ensure the following are installed and configured on the Jenkins server:

- Java 17 (Amazon Corretto)
- Maven
- Docker
- Git
- Trivy
- SonarQube (running on port `9000`)
- Jenkins running on port `8081`

---

## 🔧 Jenkins Configuration (One-Time Setup)

### 1️⃣ Required Jenkins Plugins

Install the following plugins from **Manage Jenkins → Plugins**:

- Git
- Pipeline
- Docker Pipeline
- SonarQube Scanner
- Credentials Binding

---

### 2️⃣ Global Tool Configuration

Navigate to **Manage Jenkins → Tools**

#### Java
- Name: `jdk17`
- JAVA_HOME: `/usr/lib/jvm/java-17-amazon-corretto`

#### Maven
- Name: `maven3`
- MAVEN_HOME: `/usr/share/maven`

<!-- #### sonar
- Name: sonar-server
- Server URL: http://<sonarqube-ip>:9000
- Authentication Token: add via Jenkins credentials -->

---

### 3️⃣ SonarQube Configuration

Navigate to **Manage Jenkins → System**

- SonarQube Name: `sonar-server`
- SonarQube URL: `http://localhost:9000`

#### SonarQube Token
- Generate token from SonarQube UI
- Add to Jenkins credentials:
  - Kind: `Secret Text`
  - ID: `sonar-token`

#### ❌ Why Jenkins is stuck at PENDING

Because Jenkins does NOT know the Quality Gate result yet.  
That result is sent back to Jenkins via a webhook.    
👉 You have NOT configured the SonarQube → Jenkins webhook.

Without webhook:

- Jenkins keeps polling
- Status stays PENDING
- Pipeline appears stuck

In SonarQube UI:
```
Administration → Configuration → Webhooks → Create
        or 
projectsetting -> webhooks
```

Fill:

- Name: ```jenkins```

- URL:
```http://<JENKINS_IP>:8080/sonarqube-webhook/```

✅ Save

⚠️ Note the trailing slash is mandatory

---

### 4️⃣ Docker Registry Credentials

Add Docker registry credentials in Jenkins:

- Kind: `Username/Password`
- ID: `dockerhub-creds`
- Username: DockerHub username
- Password: DockerHub password or access token

### 5 Github  Credentials
- Kind: `Username/Password`
- ID: `github-creds`
- Username: github username
- Password: PAT

---

## 📄 Pipeline Stages (High Level)

The Jenkins pipeline consists of the following stages:

```
Checkout
→ GitLeaks Scan
→ Compile
→ Dependency Check(via pom.xml)
→ Unit Tests
→ SonarQube Scan
→ Quality Gate
→ Package (JAR)
→ Docker Image Build
→ Trivy Image Scan
→ Docker Push
→ Update Manifest Repo

```
### Refer to [Jenkins Script](https://github.com/nitheesh500/spring-petclinic-mono/blob/40c5669f4000ce9d19496567cec99417ac7b58ab/Jenkinsfile)
---

## 🧪 Test Strategy

- Unit tests run as part of the Maven build
- Integration tests are skipped in CI to avoid external dependencies
- Database-backed tests are executed only in controlled environments

---

## 🔍 Code Quality

- SonarQube enforces quality gates
- Pipeline fails if quality gate conditions are not met
- Prevents low-quality code from progressing further

---

## 🔐 Security Scanning

- Trivy scans Docker images for:
  - HIGH vulnerabilities
  - CRITICAL vulnerabilities
- Results are visible in Jenkins console logs

---

## 📦 Artifact Output

- Docker image pushed to Docker registry
- Image tag follows Jenkins build number
- Image is later deployed via GitOps (Argo CD)

---

## 🧠 Best Practices Followed

- Pipeline as Code
- Least privilege access
- Non-root Docker containers
- Separation of CI and CD
- GitOps-based deployment

---

## 🚀 Next Step

After CI completion:
- Image tag is updated in the **Kubernetes manifest repository**
- Argo CD automatically deploys the new version to EKS

Refer to the [CD Setup Documentation](https://github.com/nitheesh500/DEVOPS-E2E-PROJECT/blob/c5e35fb4d2f9cf8b5448b96a69a6ecbb0b6e7d52/terraform/README-FILES/CD-SETUP.MD) for deployment details.

---
