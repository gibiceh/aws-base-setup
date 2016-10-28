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

# Purpose:
# determine if needed settings parameters have been configured
check_settings() {
  log_msg "START:  check population of setting.sh"
  blank_settings=$(grep -n '<CHANGE_ME>' ./settings.sh)
  if [ ! -z "$blank_settings" ]; then
    log_msg "$blank_settings"
    read -n1 -p "Quit and configure settings? [y,n]" user_response
    case $user_response in
      y|Y)
        echo ""
        log_msg "Quitting to configure blank settings."
        exit;
        ;;
      n|N)
        echo ""
        # needed minimal settings are configured
        ;;
      *)
        printf "\nTry again! [y|n]\n"
        ;;
    esac
  else
    log_msg "The $settings_project resources have configured settings."
  fi
}

setup_preliminaries() {
  log_msg "START:  setup of $settings_project preliminary resources"
  sh ./preliminaries/setup-preliminaries.sh
  log_msg "END:  setup of $settings_project preliminary resources"
}

setup_vpc() {
  log_msg "START:  setup of project VPC resources"
  sh ./vpc/setup-vpc-stack.sh
  log_msg "END:  setup of project VPC resources"
}

update_resources_bucket() {
  sh ./resources/upload-bootstrap-files.sh
}

function main() {
  source settings.sh
  source utilities.sh

  clear_screen

  FAIL_MSG="FAIL: pass option to build one of: [ prelim | vpc | all | update_resources_bucket ]"

  if [ -z "$ENV" ]; then
    log_msg "FAIL:  Environmental variable, ENV, needs to be set.  Example:  export ENV=dev"; exit 1
  else
    log_msg "The $settings_project resources will be created/updated in the $ENV environment."
  fi

  check_settings

  if [ "$1" == "preliminaries" ] || [ "$1" == "prelim" ]; then
    setup_preliminaries
  elif [ "$1" == "vpc" ]; then
    update_resources_bucket
    setup_vpc
  elif [ "$1" == "all" ]; then
    setup_preliminaries
    setup_vpc
  elif [ "$1" == "update_resources_bucket" ]; then
    update_resources_bucket
  else
    echo $FAIL_MSG; exit 1
  fi
}

main $1
