# syntax = 103.14.34.141:5000/docker/dockerfile

FROM 103.14.34.141:5000/sanmingzi/ruby:2.6.6-alpine AS bundle

ENV APP_PATH /workspace/wallet_manage_service
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH
COPY Gemfile* ./
COPY vendor ./vendor
RUN --mount=type=cache,target=$APP_PATH/vendor bundle install --path vendor/bundle

FROM 103.14.34.141:5000/sanmingzi/ruby:2.6.6-alpine

ENV APP_PATH /workspace/wallet_manage_service
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH
COPY . ./
COPY --from=bundle $APP_PATH .
RUN bundle install --path vendor/bundle
