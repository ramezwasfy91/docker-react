# Specify a base image
# set the base image to use for any subsequent instructions that
#follow and also give this build stage a name
FROM node:16-alpine as builder

# specify the working directory
WORKDIR '/app'

# copy dependencies first from local FS to container to avoid unnecessary dependencies re-installing
COPY package.json .

# install some dependencies
RUN npm install

# Copy everything else including the application code index.js
COPY ./ ./

# run command to start our application
# the build folder will be created in the same workdirectory after execution of below command.
# /app/build will be the folder that have all the stuff we care about.
CMD ["npm", "run", "build"]


# You'll notice that we did not have to put any terminology or any syntax in here to specify or say
#that the initial phase that we have right here was stopping by just putting in a second from statement
#that essentially says, "Okay previous block all complete don't worry about it".
FROM nginx

# putting expose 80 will do actually nothing in terms of testing locally ,
# however for elasicbeanstalk this will be used to map port numbers/
EXPOSE 80
# copy /app/build from builder phase to nginx configuration location.
COPY --from=builder /app/build /usr/share/nginx/html

# docker run -p 8080:80 docker.io/ramezwasfy91/react_frontend_prod:latest
# map port 8080 in our localhost to port 80 which is the default port on nginx.