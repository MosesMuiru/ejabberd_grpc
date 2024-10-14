FROM elixir:1.14.1-alpine AS builder

RUN apk add --no-cache openssl gcc libc-dev libstdc++ openssl-dev yaml-dev zlib-dev expat-dev g++ git make 

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./

RUN HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix deps.get


COPY config config

COPY cacert.pem certfile.pem server.pem ejabberd.yml ./

COPY lib lib

RUN mix deps.compile 

EXPOSE 5051

CMD ["mix" , "run" , "--no-halt"]
