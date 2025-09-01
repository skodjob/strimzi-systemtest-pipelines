# strimzi-systemtest-pipelines

This repository contains pipelines and configurations for running Strimzi Kafka Operator system tests in different CI systems.

## Repository Structure

- **[container/](container/)** - Container image configuration for running Strimzi system tests
  - See [container/README.md](container/README.md) for build and run instructions
- **[tekton/](tekton/)** - Tekton pipeline definitions for CI/CD integration
  - See [tekton/README.md](tekton/README.md) for pipeline setup and usage

## Overview

The Strimzi system tests validate the functionality of the Strimzi Kafka Operator across various Kubernetes environments. This repository provides the necessary infrastructure components to run these tests in containerized CI/CD pipelines.

### Container Image

The container image provides a complete testing environment with all required tools and dependencies pre-installed, including:
- OpenJDK 17
- Maven build system
- Kubernetes and OpenShift CLI tools
- Operator SDK and Helm

### Tekton Pipelines

The Tekton pipelines automate the execution of system tests in Kubernetes-native CI/CD workflows, enabling:
- Automated test execution on code changes
- Integration with various Kubernetes platforms
- Configurable test parameters and environments
