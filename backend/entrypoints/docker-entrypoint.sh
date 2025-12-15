#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

bundle exec rails db:migrate RAILS_ENV=${RAILS_ENV:-development}

bundle exec rails s -b 0.0.0.0