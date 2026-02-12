FROM node:24-slim

ARG POSTGRES_HOST
ARG POSTGRES_USERNAME
ARG POSTGRES_PWD
ARG POSTGRES_DATABASE
ENV POSTGRES_HOST_STRING "postgres://${POSTGRES_USERNAME}:${POSTGRES_PWD}@${POSTGRES_HOST}/${POSTGRES_DATABASE}"
ENV TINI_VERSION v0.19.0
ENV PORT 5001

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

WORKDIR /app

RUN npm install -g nodemon

COPY . /app

RUN npm ci \
 && npm cache clean --force \
 && mv /app/node_modules /node_modules

EXPOSE 5001

CMD ["/tini", "--", "node", "server.js", ">>", "/dev/stdout", "2>>", "/dev/stderr"]
