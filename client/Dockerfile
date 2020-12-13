FROM node:alpine

WORKDIR /usr/app

RUN apk add git

COPY . .

RUN npm install --silent

EXPOSE 8080

CMD npm run dev
