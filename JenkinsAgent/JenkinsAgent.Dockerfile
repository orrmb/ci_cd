# Use a multi-stage build for efficiency
FROM ubuntu:latest as installer

# Install curl
RUN apt-get update && apt-get install curl -y

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN apt-get install -y unzip \
    && unzip awscliv2.zip \
    && ./aws/install --bin-dir /usr/local/aws-cli/

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Snyk CLI
RUN mkdir /snyk && cd /snyk \
    && curl -L https://static.snyk.io/cli/v1.666.0/snyk-linux -o snyk \
    && chmod +x ./snyk

FROM python:3.11.8-alpine as python_builder

# Create a virtual environment
RUN python3 -m venv /venv

FROM jenkins/agent

# Copy the `docker` (client only!!!) from `docekr` image to this image.
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
# Copy tools from the installer stage
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=installer /snyk/ /usr/local/bin/snyk
# Copy the Python venv
COPY --from=python_builder /venv /venv
