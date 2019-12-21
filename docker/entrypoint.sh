#!/bin/bash

set -o xtrace
set -o errexit

cd /app

if [ "$RAILS_ENV" == 'production' ]; then
    bundle exec rails db:migrate
else
    bundle exec rails db:setup
fi

exec $@
