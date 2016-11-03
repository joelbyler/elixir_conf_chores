FROM elixir:1.3.4
MAINTAINER Joel Byler <joelbyler@gmail.com>

ENV PHOENIX_VERSION 1.2.1

RUN apt-get update && apt-get install -y inotify-tools

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install -y nodejs \
  && npm install --global brunch

ADD . /app
WORKDIR /app

RUN mix archive.install --force                                                             \
   https://github.com/phoenixframework/archives/raw/master/phoenix_new-$PHOENIX_VERSION.ez \
   && mix local.hex --force                                                                \
   && mix local.rebar --force

CMD ["mix", "phoenix.server"]

# FROM elixir:1.3.4
# MAINTAINER Joel Byler <joelbyler@gmail.com>
#
# ENV PHOENIX_VERSION 1.2.1
#
# # install psql
# RUN apt-get update && apt-get install -y inotify-tools
#
# RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
#  apt-get install -y nodejs \
#  && npm install --global brunch
#
# # install mix and rebar
# RUN mix archive.install --force                                                             \
#     https://github.com/phoenixframework/archives/raw/master/phoenix_new-$PHOENIX_VERSION.ez \
#     && mix local.hex --force                                                                \
#     && mix local.rebar --force
#
# ADD . /usr/src/app
# WORKDIR /usr/src/app
#
# # configure work directory
# # RUN mkdir -p /usr/src/app
# # WORKDIR /usr/src/app
#
# # what do we have here?
# RUN apt-get install tree
# RUN tree /usr
#
# # install dependencies
# COPY mix.* /usr/src/app/
# COPY config /usr/src/app/
# RUN mix do deps.get, deps.compile
#
# CMD ["mix", "phoenix.server"]
#
