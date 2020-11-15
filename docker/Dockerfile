#
# Build stage
#
FROM ruby:2.5-buster as build

ENV RAILS_ENV production
ENV DATABASE_URL postgresql://user:pass@127.0.0.1/dbname

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN adduser --system --group pa-dashboard

RUN install --directory --owner pa-dashboard --group pa-dashboard /app

WORKDIR /app

USER pa-dashboard

# Run bundle install before copying the whole application to take advantage
# of Docker's caching.
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 20 --retry 5 --no-cache

COPY --chown=pa-dashboard:pa-dashboard . ./

#
# Final stage
#
FROM ruby:2.5-slim-buster

ENV RAILS_ENV production

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN adduser --system --group pa-dashboard \
  \
  && mkdir -p /app/vendor/bundle \
  && chown -R pa-dashboard:pa-dashboard /app

RUN apt-get update \
    && apt-get install -y libpq5 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/local/bin/ruby /usr/local/bin/ruby2.5

WORKDIR /app

COPY --chown=pa-dashboard:pa-dashboard . ./

COPY --from=build --chown=pa-dashboard:pa-dashboard /usr/local/bundle /usr/local/bundle

COPY docker/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER pa-dashboard

ENTRYPOINT ["entrypoint.sh"]
CMD ["bin/rails", "server", "--binding", "0.0.0.0"]

EXPOSE 3000
