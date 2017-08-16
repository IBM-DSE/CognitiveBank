FROM ruby:2.4.0
ARG RAILS_ENV=development
ENV RAILS_ENV $RAILS_ENV

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /CognitiveBank
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change.
# This will drastically increase build times when your gems do not change.
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler
RUN if [ "${RAILS_ENV}" = "production" ]; then bundle install --without development test; else bundle install; fi

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# Reset the database and precompile assets in production
RUN rake db:reset
RUN if [ "${RAILS_ENV}" = "production" ]; then rake assets:precompile; fi

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$INSTALL_PATH/public"]

# Expose port 3000 to the Docker host, so we can access it from the outside.
EXPOSE 3000

# Command sets SECRET_KEY_BASE in production and starts the server
CMD if [ "${RAILS_ENV}" = "production" ]; then export SECRET_KEY_BASE=$(rake secret); fi && rails server