FROM node

WORKDIR /usr/app

RUN apk add git

COPY . .

RUN npm install

EXPOSE 8080

CMD npm run dev
