FROM ruby:2.5.7

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev\
  nodejs postgresql-client

RUN gem install bundler
RUN bundle config --global frozen 1

WORKDIR /api

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD rails server
