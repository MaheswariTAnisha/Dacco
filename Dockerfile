# Use Node.js as the base image for building the app
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the entire project
COPY . .

# Build the Vite React app
RUN npm run build

# Use Nginx to serve the built files
FROM nginx:alpine

# Set Nginx to listen on Cloud Run's expected port
ENV PORT=8080

# Copy build files to Nginx web server directory
COPY --from=build /app/dist /usr/share/nginx/html

# Replace Nginx default.conf to use $PORT
RUN sed -i 's/listen       80;/listen ${PORT};/' /etc/nginx/conf.d/default.conf

# Expose port 8080 (Cloud Run's required port)
EXPOSE 8080

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
