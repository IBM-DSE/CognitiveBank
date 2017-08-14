#!/bin/bash

echo Travis Branch: $TRAVIS_BRANCH

if [[ ${TRAVIS_BRANCH} == "deploy-w3ibm-prod-us-south-ATAT-CognitiveBank"* ]]; then
    APP_URL="https://cognitivebank.w3ibm.mybluemix.net/"
elif [[ ${TRAVIS_BRANCH} == "deploy-ibm-yp-us-south-ATAT-pub-CognitiveBank"* ]]; then
    APP_URL="https://cognitivebank-demo.mybluemix.net/"
elif [[ ${TRAVIS_BRANCH} == "deploy-ibm-yp-eu-gb-ATAT-pub-CognitiveBank"* ]]; then
    APP_URL="https://cognitivebank.eu-gb.mybluemix.net/"
elif [[ ${TRAVIS_BRANCH} == "deploy-ibm-yp-au-syd-ATAT-pub-CognitiveBank"* ]]; then
    APP_URL="https://cognitivebank.au-syd.mybluemix.net/"
else
    APP_URL=local
fi

echo Testing Target: $APP_URL