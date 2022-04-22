# Getting apache base image
FROM httpd:latest
# Copying host website files to apache container
COPY ./html/index.html /usr/local/apache2/htdocs/index.html
# Open the port for the container
EXPOSE 80