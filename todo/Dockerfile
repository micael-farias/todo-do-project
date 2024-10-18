# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t my-app .
# docker run -d -p 80:80 -p 443:443 --name my-app -e RAILS_MASTER_KEY=<value from config/master.key> my-app

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
FROM ruby:3.3.5

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client redis-server && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Set the working directory in the container
WORKDIR /myapp

# Add the Gemfile and Gemfile.lock from your app
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Install gems
RUN bundle install

# Add the rest of your app's code
COPY . /myapp

# Install and update Yarn packages
RUN yarn install --check-files

# Start Redis service
RUN service redis-server start

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
