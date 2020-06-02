#!/bin/bash
env_name=$(cat $TEMP_ENV_NAME_FILE)
echo "env_name=$env_name"

# if [[ "$env_name" == "DEV" ]]; then
#     export JENKINS_SETTING_AWS_PROFILE=dev
#     echo "Deploy will be performed on the dev account"
# fi
export JENKINS_SETTING_CF_DISABLE_ROLLBACK=true
install-cf-template
