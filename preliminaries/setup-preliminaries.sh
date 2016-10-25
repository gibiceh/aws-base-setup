#!/bin/bash
#:#########################################################################
#: Intent: This script creates a CF stack that will provision the following resources
#:              - SNS topic
#:                  - needed for alerts
#:              - S3 buckets
#:              - IAM groups, users, policies (not all are currently provisioned)
#:        This script will execute resources/upload-bootstrap-files.sh to upload
#:          resource files needed for lambda functions, ec2 bootstraping, api gateway, etc.
#:
#: Notes:
#:	- aws cli installed and configured
#:	- The s3 bucket name cannot already exist prior to running this script.
#: 	- settings.sh
#:		- contains parameters (bucket names, stack name, tags, etc)
#:			used in the Cloudformation create-stack call)
#:	- utilities.sh (contains helper functions)
#:
#:##########################################################################

# Purpose:
# check to see if iam password policy has already been created
function check_iam_password_policy() {
  local exit_code="0"

  log_msg "check for iam password policy"
  aws --profile $settings_aws_cli_profile \
    iam get-account-password-policy &>/dev/null \
    || { exit_code=$?; }

  if [ $exit_code -gt "0" ]; then
    status="false" # iam password policy does not exist
  else
    status="true" # iam password policy exists
  fi
}

# Purpose:
# setup an iam password policy on the aws account if missing
# Parameters:
# $1: minimum password length
# $2: maximum password age (in days) before reset neeeded
# $3: minimum number of iterations before you can reuse a previous password
#
# Usage:
# setup_iam_password_policy "8" "60" "4"
function setup_iam_password_policy() {
  check_iam_password_policy

  if [ $status = "true" ]; then
    log_msg "FAIL:  iam password policy already exists"
  else
    log_msg "iam password policy does not exist"

    aws --profile $settings_aws_cli_profile \
      iam update-account-password-policy \
      --minimum-password-length $1 \
      --require-uppercase-characters \
      --require-lowercase-characters \
      --require-numbers \
      --require-symbols \
      --allow-users-to-change-password \
      --max-password-age $2 \
      --password-reuse-prevention $3

    log_msg "SUCCESS:  iam password policy created"
  fi
}

function main() {
  CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  source "$CURRENT_DIR/../settings.sh"
  source "$CURRENT_DIR/../utilities.sh"

  # via cli - provision IAM password policy
  setup_iam_password_policy \
    $settings_prelim_iam_min_pw_length \
    $settings_prelim_iam_max_pw_age \
    $settings_prelim_iam_pw_reuse_prevention

  # provision cloudformation stack to create s3 buckets for cloudformation template files and environment resources
  log_msg "START:  create cloudformation stack - $settings_prelim_s3repos_stack_name"
  setup_stack \
    $settings_prelim_s3repos_stack_name \
    $settings_prelim_s3repos_stack_path \
    $settings_prelim_s3repos_master_template \
    "false" \
    "$settings_prelim_s3repos_params" \
    "false"
  log_msg "END:  create cloudformation stack - $settings_prelim_s3repos_stack_name"

  # Upload Resource files needed for lambda functions, ec2 bootstraping, api gateway, etc.
  sh $CURRENT_DIR/../resources/upload-bootstrap-files.sh

  # Provision sns alarm notification topic, optional cloudtrail for the account, lambda functions for latest ami lookup
  log_msg "START:  create cloudformation stack - $settings_prelim_stack_name"
  setup_stack \
    $settings_prelim_stack_name \
    $settings_prelim_stack_path \
    $settings_prelim_master_template \
    "$settings_prelim_s3repos_cftemplates_bucketname/preliminaries/" \
    "$settings_prelim_params" \
    "$settings_prelim_stack_policy"
  log_msg "END:  create cloudformation stack - $settings_prelim_stack_name"
}

main
