FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev sqlite3 nodejs
RUN mkdir /chita-challenge
WORKDIR /chita-challenge
COPY Gemfile /chita-challenge/Gemfile
COPY Gemfile.lock /chita-challenge/Gemfile.lock
RUN bundle install
RUN rails webpacker:install
COPY . /chita-challenge