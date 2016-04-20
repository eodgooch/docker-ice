#!/bin/bash
################################################
###                                          ###
###  Bootstrap Netflix ICE with System vars  ###
###                                          ###
### ACCESS_KEY_ID                            ###
### SECRET_KEY                               ###
### ACCESS_TOKEN                             ###
### BILLING_BUCKET                           ###
### WORK_BUCKET                              ###
### COMPANY_NAME                             ###
###                                          ###
################################################

# Check for AWS Creds Access Key parameter
if [ -z ${ACCESS_KEY_ID+x} ]; then
  echo "Please supply AWS Credentials Access Key!"
  exit 1
else
  ACCESS_KEY_ID="${ACCESS_KEY_ID}"
fi

# Check for AWS Creds Secret Key parameter
if [ -z ${SECRET_KEY+x} ]; then
  echo "Please supply AWS Credentials Secret Key!"
  exit 1
else
  SECRET_KEY="${SECRET_KEY}"
fi

# Check for AWS Creds Access Token parameter
if [ -z ${ACCESS_TOKEN+x} ]; then
  echo "Please supply AWS Credentials Access Token!"
  exit 1
else
  ACCESS_TOKEN="${ACCESS_TOKEN}"
fi

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
sed -i -e "s/%%MESOS_ZK%%/${ZK}/" \
  -e "s/%%IP%%/${LOCAL_IP}/" \
  -e "s/%%HTTP_PORT%%/${PORT}/" \
  -e "s/%%EXTERNAL_DNS_SERVERS%%/${DNS_SERVERS}/" \
  -e "s/%%HTTP_ON%%/${HTTP_ENABLED}/" \
  -e "s/%%IP_SOURCES%%/${IP_SOURCES}/" \
  -e "s/%%REFRESH%%/${REFRESH}/" \
  -e "s/%%TIMEOUT%%/${TIMEOUT}/" \
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