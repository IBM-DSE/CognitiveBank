# Cognitive Bank

## Installation

The essential pieces that you need are to install ruby, then bundler, then rails.
 
* Install Ruby: Your OS may come with ruby or have an easy way to install it. If so, use that. If not, you can use something like rbenv to manage the versions.
 
* After that, you can install Bundler as a "gem" (Ruby's package manager, like NPM) with `gem install bundler`
 
* After that you can go to the project root directory and do `bundle install` which should install all the required packages
 
* The last step is to set up the database with `rake db:setup`
 
* Finally you can run the server with `rails server`

### Docker

copy `.env.example` to `.env` and fill it in with your Bluemix service values

#### Developent
- `docker build -t cognitivebank_dev .`
- `docker run -p 3000:3000 --env-file .env cognitivebank_dev`

#### Production
- `docker build -t cognitivebank_prod --build-args RAILS_ENV=production .` 
- `docker run -p 3000:3000 --env-file .env -v CognitiveBank:/CognitiveBank/public cognitivebank_prod`