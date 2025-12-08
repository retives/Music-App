FROM ruby:3.2.2

ENV BUNDLER_VERSION=2.4.10

RUN apt update && apt install -y imagemagick

RUN gem install bundler -v 2.4.10

WORKDIR /app

COPY Gemfile* ./

RUN bundle check || bundle install

COPY . ./

EXPOSE 3000

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]