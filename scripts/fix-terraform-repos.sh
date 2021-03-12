#! /usr/bin/env bash

#
# Check repo
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly DIR

TEMPLATE_REPO="terraform-module-template"
DATE=$(date +"%s")

function git_current_branch() {
  git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'
}

function git_current_origin() {
  git config --get remote.origin.url | sed -e 's/^.*\://' | sed -e 's/\.git.*//'
}

function git_current_domain() {
  git config --get remote.origin.url | sed -e 's/^.*\@//' | sed -e 's/\:.*//'
}

function gpthis() {
    git push origin "HEAD:$(git_current_branch)"
}

function gpr() {
    open "https://$(git_current_domain)/$(git_current_origin)/pull/new/$(git_current_branch)"
}

diffcheck() {
    basedir=$1
    repo=$2
    filename=$3

    template_file="${basedir}/${TEMPLATE_REPO}/${filename}"
    remote_file="${basedir}/${repo}/${filename}"
    if [ ! -d "${basedir}/${repo}" ]; then
        return
    fi
    cp "${template_file}" "${remote_file}"
}

check() {
    repo=$1

    basedir=$(realpath "${DIR}"/../../)

    # Files we want to be exactly the same as in the template repo
    diffcheck "${basedir}" "${repo}" .circleci/config.yml
    diffcheck "${basedir}" "${repo}" scripts/format-files
    diffcheck "${basedir}" "${repo}" scripts/update-docs
    diffcheck "${basedir}" "${repo}" .gitignore
    diffcheck "${basedir}" "${repo}" .markdownlintrc
    diffcheck "${basedir}" "${repo}" .pre-commit-config.yaml
    diffcheck "${basedir}" "${repo}" LICENSE
    diffcheck "${basedir}" "${repo}" versions.tf
    pushd "${basedir}/${repo}" >> /dev/null || exit 1
    echo
    echo "===================="
    pwd
    echo
    git stash
    git checkout main || git checkout master
    git pull
    git stash apply
    git status
    git checkout -b "fix_repo_${DATE}"
    git add .
    git commit -am"Update repo to match template repo"
    gpthis
    gpr
    popd >> /dev/null || exit 1
}

check terraform-aws-acm-certificate
check terraform-aws-alb-metric-alarms
check terraform-aws-api-gateway-cloudwatch-role
check terraform-aws-api-gateway-waf
check terraform-aws-cloudfront-bucket
check terraform-aws-cloudfront-waf
check terraform-aws-cloudwatch-kms-key
check terraform-aws-cognito-user-pool
check terraform-aws-dnssec-kms-key
check terraform-aws-ds-directory
check terraform-aws-dynamodb-kms-key
check terraform-aws-ebs-kms-key
check terraform-aws-ec2-instance-role
check terraform-aws-ecr-kms-key
check terraform-aws-ecs-metric-alarms
check terraform-aws-elasticsearch-domain
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
check terraform-aws-rest-endpoint
check terraform-aws-s3-kms-key
check terraform-aws-self-manage-credentials
check terraform-aws-ses-domain
check terraform-aws-sns-kms-key
check terraform-aws-sns-topic
check terraform-aws-ssm-kms-key
check terraform-aws-sso-roles
check terraform-aws-user-management
check terraform-aws-workspaces-default-role
check terraform-aws-workspaces-kms-key
