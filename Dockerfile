ARG RUBY_VERSION=3.3.0

FROM ruby:$RUBY_VERSION-alpine

ARG NODE_MAJOR=20

# Install dependencies (build tools, Node, Yarn, libvips)
RUN apk add --update --no-cache \
      build-base \
      git \
      vips \
      sqlite-libs \
      tzdata \
      yarn \
      nodejs && \
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
RUN gem install rails

# Make the dev server listen on all interfaces
ENV BINDING="0.0.0.0"

# No entrypoint override (makes it open/interactive)
ENTRYPOINT [""]
