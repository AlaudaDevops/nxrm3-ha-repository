#!/bin/bash

set -x

export NEXUS_URL=$1
export NEXUS_USERNAME=$2
export NEXUS_PASSWORD=$3

# Get current EULA status and disclaimer
response=$(curl -s -k -u $NEXUS_USERNAME:$NEXUS_PASSWORD -X GET $NEXUS_URL/service/rest/v1/system/eula)

# Extract accepted status using jq
accepted=$(echo "$response" | jq -r '.accepted')
if [[ "$accepted" == "true" ]]; then
  echo "EULA already accepted."
else
  echo "Accepting EULA..."
  
  # Extract disclaimer from response using jq
  disclaimer=$(echo "$response" | jq -r '.disclaimer')

  # Check if disclaimer is null or empty
  if [[ -z "$disclaimer" || "$disclaimer" == "null" ]]; then
    echo "Error: Disclaimer is empty or null, cannot accept EULA."
    exit 1
  fi

  echo "Using disclaimer: $disclaimer"
  
  # Accept EULA with the disclaimer from response
  post_response=$(curl -s -w "%{http_code}" -k -u $NEXUS_USERNAME:$NEXUS_PASSWORD -X POST $NEXUS_URL/service/rest/v1/system/eula \
    -H "Content-Type: application/json" \
    -d "$(jq -nc --arg disclaimer "$disclaimer" '{accepted: true, disclaimer: $disclaimer}')")
  
  # Extract status code from the end of response
  post_http_code="${post_response: -3}"
  post_response_body="${post_response%???}"
  
  echo "POST EULA status code: $post_http_code"
  
  if [[ "$post_http_code" == "200" || "$post_http_code" == "204" ]]; then
    echo "EULA accepted successfully."
  else
    echo "Error: Failed to accept EULA. HTTP code: $post_http_code"
    echo "Response: $post_response_body"
    exit 1
  fi
fi
