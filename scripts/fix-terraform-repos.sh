#! /usr/bin/env bash

#
# Check repo
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly DIR

TEMPLATE_REPO="terraform-module-template"

diffcheck() {
    basedir=$1
    repo=$2
    filename=$3

    template_file="${basedir}/${TEMPLATE_REPO}/${filename}"
    remote_file="${basedir}/${repo}/${filename}"
    if [ ! -d "${basedir}/${repo}" ]; then
        return
    fi
    cp -v "${template_file}" "${remote_file}"
}

check() {
    repo=$1

    basedir=$(realpath "${DIR}"/../../)
    pushd "${basedir}/${repo}" >> /dev/null || exit 1

    echo
    echo "===================="
    echo "Editing files"
    pwd

    echo
    echo "===================="
    echo "Stash changes and pull latest code"
    git stash
    git checkout main || git checkout master
    git pull

    echo
    echo "===================="
    echo "Make directories"
    # Make directories
    mkdir -p .circleci/
    mkdir -p bin/
    mkdir -p examples/simple/
    mkdir -p pkg/tools/
    mkdir -p scripts/
    mkdir -p test/

    echo
    echo "===================="
    echo "Update to latest files"
    # Files we want to be exactly the same as in the template repo
    diffcheck "${basedir}" "${repo}" .circleci/config.yml
    diffcheck "${basedir}" "${repo}" pkg/tools/tools.go
    diffcheck "${basedir}" "${repo}" scripts/format-terraform
    diffcheck "${basedir}" "${repo}" scripts/lint-go
    diffcheck "${basedir}" "${repo}" scripts/terratest
    diffcheck "${basedir}" "${repo}" scripts/update-docs
    diffcheck "${basedir}" "${repo}" .editorconfig
    diffcheck "${basedir}" "${repo}" .envrc
    diffcheck "${basedir}" "${repo}" .envrc.local.template
    diffcheck "${basedir}" "${repo}" .gitignore
    diffcheck "${basedir}" "${repo}" .markdownlintrc
    diffcheck "${basedir}" "${repo}" .pre-commit-config.yaml
    diffcheck "${basedir}" "${repo}" LICENSE
    diffcheck "${basedir}" "${repo}" INTENT.md
    diffcheck "${basedir}" "${repo}" Makefile

    # Example Module
    if [ ! -f "${basedir}/examples/simple/main.tf" ]; then
      diffcheck "${basedir}" "${repo}" examples/simple/main.tf
      diffcheck "${basedir}" "${repo}" examples/simple/outputs.tf
      diffcheck "${basedir}" "${repo}" examples/simple/README.md
      diffcheck "${basedir}" "${repo}" examples/simple/variables.tf
    fi

    # Example Test
    if [ ! -f "${basedir}/test/terraform_aws_simple_test.go" ]; then
      diffcheck "${basedir}" "${repo}" test/terraform_aws_simple_test.go
    fi

    # Go.mod
    if [ ! -f "${basedir}/go.mod" ]; then
      go mod init "github.com/dod-iac/${repo}"
      go mod tidy
    fi

    echo
    echo "===================="
    echo "Remove old files"
    rm -f scripts/format-files
    rm -f .terraform-version

    echo
    echo "===================="
    echo "Repo status"
    echo
    git status

    popd >> /dev/null || exit 1
}

check terraform-aws-acm-certificate
check terraform-aws-alb-metric-alarms
check terraform-aws-api-gateway-cloudwatch-role
check terraform-aws-api-gateway-cors-lambda-proxy
check terraform-aws-api-gateway-waf
check terraform-aws-athena-iam-policy
check terraform-aws-athena-workgroup
check terraform-aws-cloudfront-bucket
check terraform-aws-cloudfront-waf
check terraform-aws-cloudwatch-kms-key
check terraform-aws-cognito-user-pool
check terraform-aws-dnssec-kms-key
check terraform-aws-ds-directory
check terraform-aws-dynamodb-kms-key
check terraform-aws-ebs-kms-key
check terraform-aws-ec2-instance-role
check terraform-aws-ecr-iam-policy
check terraform-aws-ecr-kms-key
check terraform-aws-ecr-repo
check terraform-aws-ecs-cluster
check terraform-aws-ecs-metric-alarms
check terraform-aws-ecs-scheduled-task
check terraform-aws-ecs-task-execution-role
check terraform-aws-ecs-task-role
check terraform-aws-elasticsearch-domain
check terraform-aws-glue-data-catalog-encryption
check terraform-aws-glue-iam-policy
check terraform-aws-glue-iam-role
check terraform-aws-glue-kms-key
check terraform-aws-guardduty
check terraform-aws-iam-billing-roles
check terraform-aws-kinesis-api-gateway
check terraform-aws-kinesis-firehose-s3-bucket
check terraform-aws-kinesis-iam-role
check terraform-aws-kinesis-kms-key
check terraform-aws-kinesis-stream
check terraform-aws-lambda-edge-function
check terraform-aws-lambda-function
check terraform-aws-lambda-kms-key
check terraform-aws-lambda-metric-alarms
check terraform-aws-no-delete-policy
check terraform-aws-notify-slack-kms
check terraform-aws-rest-endpoint
check terraform-aws-s3-access-logs
check terraform-aws-s3-data-to-parquet
check terraform-aws-s3-iam-policy
check terraform-aws-s3-kms-key
check terraform-aws-sagemaker-iam-role
check terraform-aws-sagemaker-kms-key
check terraform-aws-self-manage-credentials
check terraform-aws-ses-domain
check terraform-aws-sns-kms-key
check terraform-aws-sns-topic
check terraform-aws-sqs-kms-key
check terraform-aws-sqs-queue
check terraform-aws-ssm-kms-key
check terraform-aws-sso-roles
check terraform-aws-user-management
check terraform-aws-workspaces-default-role
check terraform-aws-workspaces-kms-key
