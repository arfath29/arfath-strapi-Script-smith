FROM node:18

# Use Node.js LTS version
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install
RUN npm install pg

COPY . .

RUN npm run build

ENV NODE_ENV=development


EXPOSE 1337

CMD ["npm", "run", "deploy"]
