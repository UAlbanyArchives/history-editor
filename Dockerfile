FROM ruby:3.3.4-slim-bookworm AS builder
LABEL maintainer="Gregory Wiedeman gwiedeman@albany.edu"

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test"

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Install gems
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf /usr/local/bundle/cache /usr/local/bundle/ruby/*/cache

# Copy application code
COPY . /app

# Use build secret for master key
RUN --mount=type=secret,id=master_key \
    mkdir -p /app/config && \
    cp /run/secrets/master_key /app/config/master.key && \
    RAILS_ENV=production MASTER_KEY=$(cat /app/config/master.key) bundle exec rails assets:precompile && \
    rm /app/config/master.key

# Final image
FROM ruby:3.3.4-slim-bookworm

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test"

# Runtime dependencies only. git and openssh-client are used by the backup job.
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends git openssh-client cron curl sqlite3 && \
    rm -rf /var/lib/apt/lists/*

# Copy gems and application code from the builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app
WORKDIR /app
RUN mkdir -p tmp/pids tmp/cache log storage

# Expose port 3000
ARG DEFAULT_PORT=3000
EXPOSE ${DEFAULT_PORT}

# Copy the entrypoint script
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
RUN chmod +x backup/backup_sqlite_to_csv.sh
RUN git config --global --add safe.directory /app/history-database

# Start cron and Rails server
CMD ["sh", "-c", "cron && /usr/bin/entrypoint.sh"]
