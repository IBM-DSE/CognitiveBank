#!/bin/bash

echo Travis Branch: $TRAVIS_BRANCH

if [[ ${TRAVIS_BRANCH} == "deploy-ibm-yp-us-south-ATAT-pub-CognitiveBank"* ]]; then
    APP_URL="https://cognitivebank-demo.mybluemix.net"
elif [[ ${TRAVIS_BRANCH} == "deploy-ibm-yp-eu-gb-ATAT-pub-CognitiveBank"* ]]; then
    APP_URL="https://cognitivebank.eu-gb.mybluemix.net"
elif [[ ${TRAVIS_BRANCH} == "deploy-ibm-yp-au-syd-ATAT-pub-CognitiveBank"* ]]; then
    APP_URL="https://cognitivebank.au-syd.mybluemix.net"
fi

if [ ! -z "$APP_URL" ]; then
    export APP_URL
else
    APP_URL=local
    bin/rails db:migrate RAILS_ENV=test
fi
echo Testing Target: $APP_URL
