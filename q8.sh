#!/bin/bash

set -e  # stop on error

echo "🚀 Starting Flask Deployment on Minikube..."

IMAGE_NAME="flask-app2:v1"
DEPLOYMENT_NAME="flask-deployment"
SERVICE_NAME="flask-deployment"
PORT=5000

# -------------------------------
echo "📦 Step 1: Building Docker Image..."
docker build -t $IMAGE_NAME .

# -------------------------------
echo "📥 Step 2: Loading Image into Minikube..."
minikube image load $IMAGE_NAME

# -------------------------------
echo "🧹 Step 3: Cleaning old deployment (if exists)..."
kubectl delete deployment $DEPLOYMENT_NAME --ignore-not-found=true

echo "🧹 Cleaning old service (if exists)..."
kubectl delete service $SERVICE_NAME --ignore-not-found=true

# -------------------------------
echo "🚀 Step 4: Creating Deployment..."
kubectl create deployment $DEPLOYMENT_NAME --image=$IMAGE_NAME

# -------------------------------
echo "🌐 Step 5: Exposing Service..."
kubectl expose deployment $DEPLOYMENT_NAME --type=NodePort --port=$PORT

# -------------------------------
echo "⏳ Step 6: Waiting for pods to be ready..."
sleep 5
kubectl get pods

# -------------------------------
echo "🔗 Step 7: Fetching Service URL..."
minikube service $SERVICE_NAME --url

echo "✅ Deployment Complete!"