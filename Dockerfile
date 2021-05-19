###############
# BUILD STAGE #
###############

FROM node:lts-alpine as build

# Select working directory
WORKDIR /usr/src/app

# Copy app source to work directory
COPY . .

# Diable npm update message
RUN npm config set update-notifier false

# Install app dependencies
COPY package*.json ./
RUN npm install

# Build app
COPY . .
RUN npm run build


#############
# RUN STAGE #
#############

FROM nginx:alpine

EXPOSE 80

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
