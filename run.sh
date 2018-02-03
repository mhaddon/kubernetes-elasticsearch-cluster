#!/usr/bin/env bash

minikube start

kubectl delete --all pods --namespace=tiwio

eval $(minikube docker-env)

minikube --disk-size 100g --memory 8192 --extra-config=kubelet.authorization-mode=AlwaysAllow start

kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
kubectl create -f minikube/services/dashboard.yaml

kubectl create -f es-discovery-svc.yaml
kubectl create -f es-svc.yaml
kubectl create -f es-master.yaml
kubectl rollout status -f es-master.yaml
kubectl create -f es-client.yaml
kubectl rollout status -f es-client.yaml
kubectl create -f es-data.yaml
kubectl rollout status -f es-data.yaml

kubectl create -f kibana.yaml
kubectl create -f kibana-svc.yaml

kubectl proxy & minikube dashboard