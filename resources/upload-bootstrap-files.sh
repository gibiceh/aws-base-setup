#!/bin/bash
#:#########################################################################
#: Intent: Upload resource files to s3://$settings_prelim_s3repos_resources_bucketname
#:    - ec2 bootstrap scripts
#:    - custom resources to extend cloudformation with lambda functions
#:
#: Dependencies:
#:	 - aws cli installed and configured
#:    - s3://$settings_prelim_s3repos_resources_bucketname exists
#:##########################################################################

# Purpose:
# install dependencies and zip up code to prepare for deploy to s3 resources bucket
#
# Parameters:
# $1: source folder and zip file to create
#
# Usage:
# build_custom_resource "custom-resources"
function build_custom_resource() {
  cd $CURRENT_DIR/$1/ && npm install
  zip -r $CURRENT_DIR/$1.zip .
}

function main() {
  CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  source "$CURRENT_DIR/../settings.sh"
  source "$CURRENT_DIR/../utilities.sh"

  build_custom_resource "amilookup"

  aws --profile $settings_aws_cli_profile \
    s3 sync $CURRENT_DIR s3://$settings_prelim_s3repos_resources_bucketname \
    --exclude "amilookup/*" \
    --exclude "documentation/*" \
    --exclude "sed-monsanto-tags.sh" \
    --exclude "upload-bootstrap-files.sh" \
    --delete \
    || { echo "Could not upload resource files to s3://$settings_prelim_s3repos_resources_bucketname. Does the bucket exist?"; exit 1;}
}

main
