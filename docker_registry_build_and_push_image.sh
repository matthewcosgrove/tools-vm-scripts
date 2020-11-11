#!/bin/bash
set -euo pipefail

: "${DOCKERFILE_DIR_ABSOLUTE_PATH:? DOCKERFILE_DIR_ABSOLUTE_PATH must be set to the Dockerfile directory absolute path }"
: "${DOCKER_IMAGE_NAME:? DOCKER_IMAGE_NAME must be set to the identifier e.g. mattcosgrove/govc }"
docker_registry_ip=$(credhub get -n /concourse/main/docker_registry_ip -q)
docker_registry_username=$(credhub get -n /concourse/main/docker_registry_username -q)
docker_registry_password=$(credhub get -n /concourse/main/docker_registry_password -q)
 docker login --username "${docker_registry_username}" --password "${docker_registry_password}" "${docker_registry_ip}"
pushd "${DOCKERFILE_DIR_ABSOLUTE_PATH}"
git_sha=$(git rev-parse --short HEAD)
remote_name="${docker_registry_ip}"/"${DOCKER_IMAGE_NAME}" 
path="${remote_name}":"${git_sha}"
docker build -t "${path}" .
docker tag "${path}" "${remote_name}":latest
docker push "${remote_name}"

