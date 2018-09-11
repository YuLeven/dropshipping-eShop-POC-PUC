
FROM elixir:1.7.3

RUN mix local.hex --force \
  && mix archive.install --force  https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.4.ez \
  && apt-get update \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash \
  && apt-get install -y apt-utils \
  && apt-get install -y build-essential \
  && apt-get install -y inotify-tools \
  && mix local.rebar --force

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
COPY . /app
WORKDIR $APP_HOME

RUN mix deps.get
RUN mix compile
