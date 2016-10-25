#!/bin/bash
#:#########################################################################
#: Intent: This is the high level script that is called by the user to
#:  create the AWS cloudformation stacks that will contain the resources
#:  of the environment
#:
#: Requires:
#:	- aws cli installed and configured
#:  - ENV needs to be set in shell.  example:  export ENV=dev
#: 	- settings.sh
#:		- contains parameters (bucket names, stack name, tags, etc)
#:			used in the Cloudformation create-stack call)
#:	- utilities.sh (contains helper functions)
#:    - create/update/check cloudformation stack
#:
#:##########################################################################

setup-preliminaries() {
  log_msg "START:  setup of $settings_project preliminary resources"
  sh ./preliminaries/setup-preliminaries.sh
  log_msg "END:  setup of $settings_project preliminary resources"
}

setup-vpc() {
  log_msg "START:  setup of $settings_project VPC resources"
  sh ./vpc/setup-vpc-stack.sh
  log_msg "END:  setup of $settings_project VPC resources"
  log_msg "START:  setup of preliminary project resources"
  sh ./preliminaries/setup-preliminaries.sh
  log_msg "END:  setup of preliminary project resources"
}

setup-vpc() {
  log_msg "START:  setup of project VPC resources"
  sh ./vpc/setup-vpc-stack.sh
  log_msg "END:  setup of project VPC resources"
}

update-resources-bucket() {
  sh ./resources/upload-bootstrap-files.sh
}

function main() {
  source settings.sh
  source utilities.sh

  clear_screen

  FAIL_MSG="FAIL: pass option to build one of: [ prelim | vpc | all | update-resources-bucket ]"

  if [ -z "$ENV" ]; then
    log_msg "FAIL:  Environmental variable, ENV, needs to be set.  Example:  export ENV=dev"; exit 1
  else
    log_msg "The $settings_project resources will be created/updated in the $ENV environment."
  fi

  if [ "$1" == "preliminaries" ] || [ "$1" == "prelim" ]; then
    setup-preliminaries
  elif [ "$1" == "vpc" ]; then
    update-resources-bucket
    setup-vpc
  elif [ "$1" == "all" ]; then
    setup-preliminaries
    setup-vpc
  elif [ "$1" == "update-resources-bucket" ]; then
    update-resources-bucket
  else
    echo $FAIL_MSG; exit 1
  fi
}

main $1
