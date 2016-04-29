FROM ultrayoshi/elixir
MAINTAINER david.morcillo@gmail.com

ENV APP_HOME /code
WORKDIR $APP_HOME
ADD . $APP_HOME

RUN mix hex.info
RUN mix deps.get
RUN mix escript.build

ENTRYPOINT ["./luckdragon"]

