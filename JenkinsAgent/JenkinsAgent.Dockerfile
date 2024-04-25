# docker build -f <PATH_TO_DOCKERFILE> -t <IMG_NAME> .
FROM ubuntu:latest as installer
RUN apt-get update && apt-get install curl -y
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN apt-get install -y unzip \
  && unzip awscliv2.zip \
  && ./aws/install --bin-dir /aws-cli-bin/ \
#Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
RUN sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# this is an example demostrating how to install a tool on a some Docker image, then copy its artifacts to another image
RUN mkdir /snyk && cd /snyk \
    && curl https://static.snyk.io/cli/v1.666.0/snyk-linux -o snyk \
    && chmod +x ./snyk



FROM python:3.11.8-alpine as pyton_builder
RUN python -m venv /usr/local/bin/python3


FROM jenkins/agent

# Copy the `docker` (client only!!!) from `docekr` image to this image.
COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
COPY --from=installer /snyk/ /usr/local/bin/
COPY --from=installer /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=pyton_builder /usr/local/bin/python3/venv/ /usr/local/bin/python3/venv/