# Cognitive Bank
[![Build Status](https://travis-ci.org/IBM-DSE/CognitiveBank.svg?branch=master)](https://travis-ci.org/IBM-DSE/CognitiveBank)

## Installation

### Manual

The essential pieces that you need are to install ruby, then bundler, then rails.
 
* Install Ruby 2.4.0 with one of the following:
  - [rbenv](https://github.com/rbenv/rbenv#installation)
  - [RVM](https://rvm.io/rvm/install)
  
  Or visit the official [Installing Ruby](https://www.ruby-lang.org/en/documentation/installation/) documentation for an alternative
 
* Install Bundler as a "gem" (Ruby's package manager, like NPM)
    ```bash
    gem install bundler
    ```
* Clone this repository and change directory to project root
    ```bash
    git clone https://github.ibm.com/ATAT/CognitiveBank.git && cd CognitiveBank
    ```
* Install packages with bundler
    ```bash
    bundle install
    ```
* Set up the database
    ```bash
    rails db:setup
    ```
* Run the server in development mode
    ```bash
    rails server
    ```
* Visit [http://localhost:3000](http://localhost:3000) from a browser

### Docker

copy `.env.example` to `.env` in your working directory and fill it in with your Bluemix service values

#### Quick Deploy in Development Mode
With `docker` from GitHub:
```bash
docker build -t cognitivebank_dev https://github.ibm.com/ATAT/CognitiveBank.git
docker run -it -p 3000:3000 --env-file .env cognitivebank_dev
```
With `docker` from local code:
```bash
docker build -t cognitivebank_dev .
docker run -it -p 3000:3000 --env-file .env cognitivebank_dev
```
With `docker-compose` from local code:
```bash
docker-compose build
docker-compose up
```
Visit [http://localhost:3000](http://localhost:3000) from a browser

#### Local Development with Live Reload
```bash
git clone https://github.ibm.com/ATAT/CognitiveBank.git && cd CognitiveBank
docker build -t cognitivebank_dev .
docker run -it -p 3000:3000 --env-file ../.env -v `pwd`:`pwd` -w `pwd` cognitivebank_dev rails db:migrate && rails server
```
Visit [http://localhost:3000](http://localhost:3000) from a browser</br>
Modify any files in `/app` and refresh browser to view updates

#### Production
(These instructions are for Ubuntu, other OSes may be different)
- Get a domain name and point it to your server
- Open ports 80 and 443
- [Install NGINX](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/) on your server
- Copy `production/CognitiveBank-nginx` to `/etc/nginx/sites-available/CognitiveBank` on your server
- Modify the file on your server (`/etc/nginx/sites-available/CognitiveBank`) with the domain name pointing to your server:
    ```
    server_name <DOMAIN_NAME>;
    ```
- Enable the new site configuration
    ```bash
    cd /etc/nginx/sites-enabled
    rm default
    ln -s /etc/nginx/sites-available/CognitiveBank CognitiveBank
    ```
- Run [certbot](https://certbot.eff.org/) on your server to get an SSL certificate
- Build and run the docker container
    ```bash
    docker build -t cognitivebank_prod --build-arg RAILS_ENV=production https://github.ibm.com/ATAT/CognitiveBank.git
    docker run -d -p 3000:3000 --env-file .env -v CognitiveBank:/CognitiveBank/public cognitivebank_prod
    ```
- Visit your domain name from a browser