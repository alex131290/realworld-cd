#! /bin/bash 
# /bin/bash -xe
echo "ENVIRONMENT=${ENVIRONMENT}"
# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
# Make shell to be case insensitive
shopt -s nocasematch
case "${ENVIRONMENT}" in
    *dev* | *development*)
        export SERVICE_MAX_TASKS=1
        echo "Deployment is dev, setting the number of maximum tasks to ${SERVICE_MAX_TASKS}"
        export SERVICE_MIN_TASKS=1
        echo "Deployment is dev, setting the number of minimum tasks to ${SERVICE_MIN_TASKS}"
        export DEPLOYMENT_ENVIRONMENT=DEV
        echo "Deployment dev, setting the deployment environment to ${DEPLOYMENT_ENVIRONMENT}"
        ;;
    *qa*)
        export SERVICE_MAX_TASKS=1
        echo "Deployment is qa, setting the number of maximum tasks to ${SERVICE_MAX_TASKS}"
        export SERVICE_MIN_TASKS=1
        echo "Deployment is qa, setting the number of minimum tasks to ${SERVICE_MIN_TASKS}"
        export DEPLOYMENT_ENVIRONMENT=QA
        echo "Deployment is qa, setting the deployment environment to ${DEPLOYMENT_ENVIRONMENT}"
        ;;
    *prod* | *production*)
        export SERVICE_MAX_TASKS=1000
        echo "Deployment is production, setting the number of maximum tasks to ${SERVICE_MAX_TASKS}"
        export SERVICE_MIN_TASKS=1
        echo "Deployment is production, setting the number of minimum tasks to ${SERVICE_MIN_TASKS}"
        export DEPLOYMENT_ENVIRONMENT=PRODUCTION
        echo "Deployment is production, setting the deployment environment to ${DEPLOYMENT_ENVIRONMENT}"
        ;;
    *staging* | *stage*)
        export SERVICE_MAX_TASKS=1
        echo "Deployment is staging, setting the number of maximum tasks to ${SERVICE_MAX_TASKS}"
        export SERVICE_MIN_TASKS=1
        echo "Deployment is staging, setting the number of minimum tasks to ${SERVICE_MIN_TASKS}"
        export DEPLOYMENT_ENVIRONMENT=STAGING
        echo "Deployment is staging, setting the deployment environment to ${DEPLOYMENT_ENVIRONMENT}"
        ;;
    *)
        export SERVICE_MAX_TASKS=1
        echo "Undefined environment... setting the number of maximum tasks to ${SERVICE_MAX_TASKS}"
        export SERVICE_MIN_TASKS=1
        echo "Undefined environment... setting the number of maximum tasks to ${SERVICE_MIN_TASKS}"
        export DEPLOYMENT_ENVIRONMENT=DEV
        echo "Undefined environment... setting the deployment environment to ${DEPLOYMENT_ENVIRONMENT}"
        ;;
esac

# Turn off shell case insensitive
shopt -u nocasematch

echo "$DEPLOYMENT_ENVIRONMENT" > $TEMP_ENV_NAME_FILE

export DESIRED_NUMBER_OF_TASKS="$SERVICE_MIN_TASKS"
echo "Setting the desired number of tasks to $DESIRED_NUMBER_OF_TASKS"


mkdir -p $CF_PARAMETERS_FOLDER
pip2 install jinja2
python -c 'import os
import sys
import jinja2
sys.stdout.write(
    jinja2.Template(undefined=jinja2.StrictUndefined, source=sys.stdin.read()
).render(env=os.environ))' < ${JINJA_CF_PARAMS_TEMPLATE_FILE_PATH} > ${CF_PARAMETERS_FILE_PATH}

echo "The output of the ${CF_PARAMETERS_FILE_PATH}"
cat ${CF_PARAMETERS_FILE_PATH}
