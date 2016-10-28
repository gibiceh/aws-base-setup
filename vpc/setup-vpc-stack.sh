#!/bin/bash
#:#########################################################################
#: Intent: 	This script creates a nested CloudFormation stack that stands up the
#:						VPC environment
#: Dependencies:
#:	- aws cli installed and configured
#:	- preliminaries stack implemented
#:  - ENV needs to be set in shell.  example:  export ENV=dev
#: 	- The S3 bucket (s3://$settings_prelim_s3repos_cftemplates_bucketname/vpc) that houses the templates must exist.
#:	- ../settings.sh
#:	- ../utilities.sh
#:
#:##########################################################################

function main() {
	CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  source "$CURRENT_DIR/../settings.sh"
  source "$CURRENT_DIR/../utilities.sh"

	# provision cloudformation stack to create ...
  log_msg "START:  create cloudformation stack - $settings_vpc_stack_name"

	setup_stack \
    $settings_vpc_stack_name \
    $settings_vpc_stack_path \
    $settings_vpc_master_template \
    "$settings_prelim_s3repos_cftemplates_bucketname/vpc/" \
    "$settings_vpc_params" \
		"$settings_vpc_stack_policy"

	log_msg "END:  create cloudformation stack - $settings_vpc_stack_name"
}

main
