#!/bin/bash
set -euo pipefail

docker_registry_url=$(credhub get -n /concourse/main/docker_registry_url -q)
docker_registry_username=$(credhub get -n /concourse/main/docker_registry_username -q)
docker_registry_password=$(credhub get -n /concourse/main/docker_registry_password -q)
curl -u "${docker_registry_username}":"${docker_registry_password}" -X GET "${docker_registry_url}"
# TODO: for each repository list tags
# image_name="ubuntu"
# curl -X GET https://"${docker_registry_ip}":5000/v2/"${image_name}"/tags/list
