# Our Docker image will be based on ruby:2-slim
# it is a very light docker image.
FROM ruby:2-slim
LABEL author="Nulldoot2k"
LABEL version="v1.0"
# LABEL version="3.1.2"

ENV BUNDLER_VERSION 2.3.16
RUN apt-get update
RUN apt-get install apt-utils
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    bats \
    build-essential \
    ca-certificates \
    curl \
    libffi7 \
    make \
    shellcheck \
    libffi7 \
    git\
    git-all \
    && gem install bundler:2.3.16 \
    && bundle config --global silence_root_warning 1

# This is our entrypoint to our custom scripts
# more about that in a sec
COPY entrypoint.sh /entrypoint.sh

# Use the entrypoint.sh file as the container entrypoint
# when Github executes our Docker container
ENTRYPOINT ["sh", "/entrypoint.sh"]
