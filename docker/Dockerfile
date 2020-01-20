ARG user=pa-dashboard

# Build stage
FROM debian:buster as build

ARG user

ENV RAILS_ENV production
ENV DATABASE_URL postgresql://user:pass@127.0.0.1/dbname

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN adduser --system --group $user

RUN install --directory --owner $user --group $user /app
WORKDIR /app

USER $user

# Run bundle install before copying the whole application to take advantage
# of Docker's caching.
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development --deployment --jobs 20 --retry 5 --no-cache

COPY --chown=$user:$user . ./

# Final stage
FROM ruby:2.5-buster

ARG user

ENV RAILS_ENV production

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN adduser --system --group $user \
  \
  && mkdir -p /app/vendor/bundle
  && chown -R $user:$user /app

WORKDIR /app

COPY --chown=$user:$user . ./

COPY --from=build --chown=$user:$user /app/vendor/bundle ./vendor/bundle
COPY --from=build --chown=$user:$user /usr/local/bundle/config /usr/local/bundle/config

COPY docker/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER $user

ENTRYPOINT ["entrypoint.sh"]
CMD ["bin/rails", "server"]

EXPOSE 3000
