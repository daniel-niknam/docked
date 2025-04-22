ARG RUBY_VERSION=3.3.0

FROM ruby:$RUBY_VERSION-alpine

ARG NODE_MAJOR=20

# Install dependencies (build tools, Node, Yarn, libvips)
RUN apk add --update --no-cache \
      # essentials
      build-base git \
      # image processing
      vips \
      # for rails timezone
      tzdata \
      # for rails javascript
      yarn \
      nodejs \
      # database support
      postgresql-dev mysql-dev && \
      # Clean up temp files
      rm -rf /tmp/*

# Set working directory
WORKDIR /rails

# Gems volume for caching & reuse
RUN mkdir /bundle && chmod -R ugo+rwt /bundle
VOLUME /bundle
ENV BUNDLE_PATH='/bundle'
ENV PATH="/bundle/ruby/$RUBY_VERSION/bin:${PATH}"

# Install Rails
# The bundle config is for fixing the issue for sqlite
# more info: https://github.com/sparklemotion/sqlite3-ruby/issues/434#issuecomment-1856244508
RUN bundle config force_ruby_platform true && \
    gem install rails --no-document

# Make the dev server listen on all interfaces
ENV BINDING="0.0.0.0"

# No entrypoint override (makes it open/interactive)
ENTRYPOINT [""]
