# FastAPI ML Skeleton — DevOps Practice

Production-ready ML-сервис (прогнозирование цен на жилье) с полным DevOps pipeline.

## Стек технологий
- **FastAPI** — REST API для ML-модели
- **Docker** — контейнеризация
- **Kubernetes (kind)** — оркестрация
- **Helm** — управление развёртыванием (IaC)
- **Prometheus + Grafana** — мониторинг
- **GitLab CI/CD** — автоматизация сборки и деплоя

## Требования
- Python 3.11+
- Poetry
- Docker
- kubectl, Helm
- kind или Docker Desktop Kubernetes

## Быстрый старт

### Локально (без контейнеров)
```bash
poetry install
cp .env.example .env
# Сгенерировать API_KEY: python -c "import uuid; print(uuid.uuid4())"
uvicorn fastapi_skeleton.main:app
# http://localhost:8000/docs
Docker
bash
docker build -t fastapi-ml-skeleton:local .
docker run --rm -p 8000:8000 --env-file .env fastapi-ml-skeleton:local
Kubernetes + Helm (prod-like)
bash
# Создать кластер
kind create cluster
kind load docker-image fastapi-ml-skeleton:local --name kind

# Развернуть через Helm
kubectl create namespace leadscore
kubectl create secret generic fastapi-ml-secret -n leadscore --from-literal=API_KEY="<key>"
helm upgrade --install fastapi-ml ./helm/fastapi-ml -n leadscore

# Открыть приложение
kubectl -n leadscore port-forward svc/fastapi-ml-svc 8000:80
# http://localhost:8000/docs
Мониторинг
bash
# Установить Prometheus + Grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install kube-prom-stack prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

# Prometheus (http://localhost:9090)
kubectl -n monitoring port-forward svc/kube-prom-stack-kube-prome-prometheus 9090:9090

# Grafana (http://localhost:3000)
kubectl -n monitoring port-forward svc/kube-prom-stack-grafana 3000:80
CI/CD (GitLab)
.gitlab-ci.yml содержит:

build — сборка Docker-образа и пуш в GitLab Container Registry

deploy — деплой в Kubernetes через Helm (namespace staging)

Триггер: push в main ветку.

Тестирование
bash
./scripts/linting.sh   # isort, mypy, flake8, black, bandit
./scripts/test.sh      # pytest с покрытием

Версия
v.2.0.0 — DevOps Practice (Docker + K8s + Helm + CI/CD + Мониторинг)

MIT