FROM node:20-alpine AS build-stage

WORKDIR /app
COPY package*.json ./
RUN npm install

ARG BUILD_ID=local
ENV VITE_BUILD_ID=$BUILD_ID

COPY . .
RUN npm run build 

#stage 2
FROM nginx:alpine AS second-stage

COPY --from=build-stage /app/dist/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]