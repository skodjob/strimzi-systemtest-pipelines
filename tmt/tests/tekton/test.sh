#!/bin/sh -eux

# Move to root folder
cd ../../../

# Get host IP for kind registry
HOST=$(hostname --ip-address | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | awk '$1 != "127.0.0.1" { print $1 }' | head -1)

# Create namespace
kubectl create ns test

# Create secret
kubectl create secret generic kubeconfig --from-file=config=$HOME/.kube/config

# Create PVC for test results
kubectl create -n test -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-results-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
EOF

# Deploy tkn resources
kubectl apply -f tekton/task.yaml -n test
kubectl apply -f tekton/pipeline.yaml -n test

# Run pipeline with kind registry image
tkn pipeline start strimzi-systemtest \
  --param test-image="${HOST}:5001/strimzi-systemtest:latest" \
  --param test-profile="smoke" \
  --param kubeconfig-secret=kubeconfig \
  --param test-groups="" \
  --param parallel-tests="1" \
  --param maven-args="" \
  --param env-configmap="dummy" \
  --workspace name=test-results,claimName=test-results-pvc \
  --namespace test \
  --showlog
