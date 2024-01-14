#Use the official base image
FROM node:14

#Select a working directory
WORKDIR /usr/src/app

#Copy the package.json files into working directory
COPY package*.json ./

#Install the application dependencies inside the container
RUN npm install

#Copy rest of the app code into container
COPY . .

#Specify the command to run when container starts
CMD ["node", "index.js"]
