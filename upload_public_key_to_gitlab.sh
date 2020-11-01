#!/bin/bash
set -euo pipefail

: "${GITLAB_FQDN:? GITLAB_FQDN must be set to the GitLab host of your remote repo e.g. gitlab.com or maybe gitlab.myinternalcompany.com }"
: "${GITLAB_PERSONAL_ACCESS_TOKEN:? GITLAB_PERSONAL_ACCESS_TOKEN must be set to the GitLab personal access token created with api scope via https://$GITLAB_FQDN/profile/personal_access_tokens }"
public_key=$( cat /home/ubuntu/.ssh/id_rsa.pub )
public_key_title=${public_key#ssh-rsa * } # https://tldp.org/LDP/abs/html/parameter-substitution.html
curl -k -X POST --header "PRIVATE-TOKEN: ${GITLAB_PERSONAL_ACCESS_TOKEN}" -F "title=$public_key_title" -F "key=$public_key" "https://${GITLAB_FQDN}/api/v4/user/keys"
