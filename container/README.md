# Strimzi System Tests Container

This container image is designed for running Strimzi Kafka Operator system tests in a containerized environment.

## Building the Container Image

To build the container image, run the following command from the container directory:

```bash
podman build -t strimzi-systemtest:latest -f Containerfile .
```

Or using Docker:

```bash
docker build -t strimzi-systemtest:latest -f Containerfile .
```

Add own strimzi sources to the container image

```bash
podman build -t strimzi-systemtest:latest \
  --build-arg STRIMZI_REPO_URL=https://github.com/kornys/strimzi-kafka-operator \
  --build-arg STRIMZI_REPO_BRANCH=fix-v2 \
  -f Containerfile .
```

## Running the Container

### Basic Run (Smoke Tests)

To run tests against a Kubernetes cluster, mount your kubeconfig:

```bash
podman run --rm \
  -v ~/.kube:/opt/strimzi/.kube:Z \
  strimzi-systemtest:latest
```

### Running Custom Test Commands

To run specific tests or with different Maven profiles:

```bash
# Run acceptance tests
podman run --rm \
  -v ~/.kube:/opt/strimzi/.kube:Z \
  strimzi-systemtest:latest \
  mvn verify -Pacceptance -pl systemtest

# Run with custom parameters
podman run --rm \
  -v ~/.kube:/opt/strimzi/.kube:Z \
  strimzi-systemtest:latest \
  mvn verify -pl systemtest -Dtest=ConnectST
```

### Interactive Shell

To access the container interactively:

```bash
podman run --rm -it \
  -v ~/.kube:/opt/strimzi/.kube:Z \
  --entrypoint /bin/bash \
  strimzi-systemtest:latest
```

## Container Details

- **Base Image**: UBI9 OpenJDK 17
- **Working Directory**: `/opt/strimzi`
- **User**: `strimzi` (UID: 1001)
- **Installed Tools**: git, kubectl, oc, operator-sdk, helm3
- **Maven Options**: `-Xmx2048m -XX:+UseContainerSupport`

## Volume Mounts

- `/opt/strimzi/.kube` - Mount your Kubernetes configuration directory here

## Environment Variables

- `STRIMZI_HOME=/opt/strimzi`
- `KUBECONFIG=/opt/strimzi/.kube/config`
- `MAVEN_OPTS=-Xmx2048m -XX:+UseContainerSupport`