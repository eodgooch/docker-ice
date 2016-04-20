#!/bin/bash
################################################
###                                          ###
###  Bootstrap Netflix ICE with System vars  ###
###                                          ###
### BILLING_BUCKET                           ###
### WORK_BUCKET                              ###
### COMPANY_NAME                             ###
###                                          ###
################################################

# Check for S3 billing bucket parameter
if [ -z ${BILLING_BUCKET+x} ]; then
  echo "Please supply AWS S3 Bucket with Billing data!"
  exit 1
else
  BILLING_BUCKET="${BILLING_BUCKET}"
fi

# Check for S3 work bucket parameter
if [ -z ${WORK_BUCKET+x} ]; then
  echo "Please supply AWS S3 Work Bucket with Billing data!"
  exit 1
else
  WORK_BUCKET="${WORK_BUCKET}"
fi

# Check for Company Name parameter
if [ -z ${COMPANY_NAME+x} ]; then
  COMPANY_NAME="My Company"
else
  COMPANY_NAME="${COMPANY_NAME}"
fi

# Replace network interface name
sed -i -e "s/%%COMPANY_NAME%%/${COMPANY_NAME}/" \
  -e "s/%%WORK_BUCKET%%/${WORK_BUCKET}/" \
  -e "s/%%BILLING_BUCKET%%/${BILLING_BUCKET}/" |
  ${PROPS_DIR}/ice.properties

set -e

# Set default environment variables
export GRAILS_SERVER_URL=${GRAILS_SERVER_URL:=http://localhost:8080/}

# Print used environment variables
echo "Using environment variables:"
echo "---------------------------------------------------------"
echo "> GRAILS_SERVER_URL=${GRAILS_SERVER_URL}"
echo

echo "Setting grails.serverURL in /opt/ice/grails-app/conf/Config.groovy"
sed -i "s|http://localhost:8080/|${GRAILS_SERVER_URL}|" /opt/ice/grails-app/conf/Config.groovy
echo

echo "Starting Netflix Ice:"
echo "---------------------------------------------------------"
exec /opt/ice/grailsw ${ICE_ARGUMENTS}