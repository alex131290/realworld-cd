pipeline {
    agent {label 'fargate-cloudformation-slave'}
    environment {
        COMPONENT_NAME = "realworld"
        JENKINS_CF_STACK_NAME = "${COMPONENT_NAME}-${ENVIRONMENT}"
        JENKINS_CF_TEMPLATE_NAME = "master.yaml"
        JENKINS_CF_PARAMETERS_NAME = "params.json"
        JENKINS_SETTING_AWS_REGION = "${AWS_REGION}"
        JENKINS_SETTING_ENVIRONMENT_DEPLOY = "cd/cloudformation"
        JENKINS_SETTING_CF_CAPABILITIES_NAME = "CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND"
        CF_PARAMETERS_FOLDER = "${WORKSPACE}/${JENKINS_SETTING_ENVIRONMENT_DEPLOY}/${JENKINS_SETTING_AWS_REGION}"
        CF_PARAMETERS_FILE_PATH = "${CF_PARAMETERS_FOLDER}/${JENKINS_CF_PARAMETERS_NAME}"
        JINJA_CF_PARAMS_TEMPLATE_FILE_PATH = "${WORKSPACE}/${JENKINS_SETTING_ENVIRONMENT_DEPLOY}/params.j2"
        JENKINS_SCRIPTS="${WORKSPACE}/cd/scripts/jenkins"
        S3_INFRA_BUCKET="realworld-cloudformation-infra-templates"
        TEMP_ENV_NAME_FILE="${WORKSPACE}/env.name"
    }
    options { timestamps () }
    stages {
        stage('Set display name') {
            steps {
                script {
                    currentBuild.displayName = "#${currentBuild.number} (deployment: ${env.ENVIRONMENT})"
                }
            }
        }
        stage ('create-cf-params') {
            steps {
                sh '''bash -xe ${JENKINS_SCRIPTS}/generate-cf-params-file.sh
                '''
            }
        }
        stage ('upload-cf-templates-to-s3') {
            steps {
                sh '''aws s3 sync --exclude '*' --include '*.yaml' ${JENKINS_SETTING_ENVIRONMENT_DEPLOY} s3://${S3_INFRA_BUCKET}/${COMPONENT_NAME}/${ENVIRONMENT}
                '''
            }
        }
        stage ('deploy') {
            steps {
                sh '''
                bash -xe ${JENKINS_SCRIPTS}/deploy-wrapper.sh
                '''
            }
        }
        stage ('print-url') {
            steps {
                sh '''
                echo "The frontend URL is:"
                aws cloudformation describe-stacks --stack-name "${JENKINS_CF_STACK_NAME}" --region "${JENKINS_SETTING_AWS_REGION}" --query "Stacks[0].Outputs[?OutputKey=='FrontendUrl'].OutputValue" --output text
                '''
            }
        }
    }
}
