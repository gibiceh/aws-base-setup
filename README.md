# Purpose
Maintain a generic set of starter cloudformation templates to create repeatable environments.  Fork from the branch with the best matching foundation to start your project from.

# Overview
Utilize bash scripts in combination with the awscli to create cloudformation stacks to provision an AWS environment.

#### Base
* s3 bucket to host cloudformation templates
* s3 bucket to host assets needed by the environment
  * bootstrapping files
  * scripts
  * installation files
* VPC
  * public subnet
  * public subnet ACL
  * route tables
  * internet gateway
* *Preliminary Account Setup (Optional)*
  * password policy
  * iam group:  administrator
  * iam group: power user
  * cloudtrail setup
  * cloudwatch billing alerts

# Features
* Selective Resource Creation
  * The user has the ability to prevent resource creation by adding the follow condition to the resource block which should not be created
  * "Condition" : "doNotCreateStack"


# Usage
1. settings.sh
  * copy from settings.sh.example to settings.sh
  * populate <CHANGE_ME> where seen
