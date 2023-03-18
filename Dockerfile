# USING NGINX AS BASE IMAGE
FROM nginx:latest

# INSTALL NPM, NODEJS USING NODESOURCE
RUN apt update && apt install curl -y
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt install nodejs -y

# INSTALL PM2
RUN npm install -g pm2

# SET ENVIRONMENT VARIABLES TO CONNECT MONGODB
ENV MONGO_HOST=localhost \
    MONGO_DB=firstmongo

# SET WORKING DIRECTORY
WORKDIR /home/app

# INSTALL YARN
RUN npm install -g yarn
RUN yarn


# COPY FILES TO WORKING DIRECTORY
COPY . /home/app

# COPY THE DEFAULT CONFIGURATION FILE FROM WORKING DIRECTORY
RUN rm /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d

# EXPOSE TO PORT 80
EXPOSE 80

# START NGINX AND PM2 WITH A NAME FLAG
CMD service nginx start && pm2-runtime start script.js --name backend-app
