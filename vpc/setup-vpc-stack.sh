#!/bin/bash
#:#########################################################################
#: Intent: 	This script creates a nested CloudFormation stack that stands up the
<<<<<<< HEAD
#:						pim VPC environment
=======
#:						VPC environment
>>>>>>> 9b7d460039404db119ef7086991afccd58f2ce73
#:
#: Inputs:
#:	none
#:
#: Dependencies:
<<<<<<< HEAD
=======
#:  - ENV needs to be set in shell.  example:  export ENV=dev
>>>>>>> 9b7d460039404db119ef7086991afccd58f2ce73
#: 	- The S3 bucket (s3://$settings_prelim_s3repos_cftemplates_bucketname/vpc) that houses the templates must exist.
#:	- valid ec2 keypair.
#:	- ../settings.sh
#:	- ../utilities.sh
<<<<<<< HEAD
#:
=======
>>>>>>> 9b7d460039404db119ef7086991afccd58f2ce73
#:##########################################################################

function main() {
	CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  source "$CURRENT_DIR/../settings.sh"
  source "$CURRENT_DIR/../utilities.sh"

<<<<<<< HEAD
=======
	# Upload Resource files needed for ec2 bootstrapping, etc
  ###sh $CURRENT_DIR/../resources/upload-bootstrap-files.sh

>>>>>>> 9b7d460039404db119ef7086991afccd58f2ce73
	# provision cloudformation stack to create ...
  log_msg "START:  create cloudformation stack - $settings_vpc_stack_name"

	setup_stack \
    $settings_vpc_stack_name \
    $settings_vpc_stack_path \
    $settings_vpc_master_template \
    "$settings_prelim_s3repos_cftemplates_bucketname/vpc/" \
    "$settings_vpc_params" \
<<<<<<< HEAD
		"$settings_default_stack_policy"
=======
		"$settings_vpc_stack_policy"
>>>>>>> 9b7d460039404db119ef7086991afccd58f2ce73

	log_msg "END:  create cloudformation stack - $settings_vpc_stack_name"
}

main
