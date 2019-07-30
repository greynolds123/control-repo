# Ensure your current working directory is the top folder of the repo clone
# Build:
#    docker build --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" -t myspec .
#       Replace ~/.ssh/id_rsa with the path to a key with privs to puppetlabs repos and doesn't require a password
# Run:
#     docker run -it -v `pwd`:/code myspec
FROM ruby:2.5.1-alpine
RUN apk add --no-cache git openssh ruby-dev make libxml2 libxslt-dev g++

ARG ssh_prv_key
RUN mkdir -p /root/.ssh && chmod 0700 /root/.ssh && ssh-keyscan github.com > /root/.ssh/known_hosts
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && chmod 0600 /root/.ssh/id_rsa

RUN mkdir -p /bundle
WORKDIR /bundle
ADD Gemfile /bundle
ADD Rakefile /bundle
RUN bundle install --path=/bundle/.bundle
ENV BUNDLE_GEMFILE=/bundle/Gemfile

VOLUME /code
WORKDIR /code
ENTRYPOINT ["bundle","exec","rake"]
CMD ["parallel_spec"]
