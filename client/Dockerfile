FROM node:lts-alpine

WORKDIR /usr/app

COPY package*.json ./

RUN apk add git

RUN yarn

COPY . .

EXPOSE 8080

CMD yarn dev
