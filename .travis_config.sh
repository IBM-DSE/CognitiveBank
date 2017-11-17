#!/bin/bash

echo Travis Branch: $TRAVIS_BRANCH

if [[ ${TRAVIS_BRANCH} == "deploy-ibm-yp-us-south-IBM-ATAT-CognitiveBank"* ]]; then
    APP_URL="https://cognitivebank-test.mybluemix.net/"
fi

if [ ! -z "$APP_URL" ]; then
    export APP_URL
else
    APP_URL=local
    bin/rails db:migrate RAILS_ENV=test
fi
echo Testing Target: $APP_URL
