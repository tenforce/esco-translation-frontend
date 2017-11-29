FROM node:4 AS build
LABEL authors="Cecile Tonglet <cecile.tonglet@tenforce.com>"
ARG env=dev

RUN npm -q set progress=false
RUN npm install -q -g bower

RUN mkdir /src
WORKDIR /src

ADD package.json /src/
RUN npm install -q

ADD bower.json /src/
RUN bower --allow-root install

ENV PATH=/src/node_modules/ember-cli/bin:$PATH

COPY . /src/
RUN ember build --$env >/dev/null


FROM semtech/mu-nginx-spa-proxy
COPY --from=build /src/dist /app
COPY nginx/app.conf /etc/nginx/conf.d
