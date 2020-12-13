FROM node:alpine

WORKDIR /usr/app

COPY package*.json ./

RUN apk add git

RUN npm install --silent

COPY . .

EXPOSE 8080

CMD npm run dev
