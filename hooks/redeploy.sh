#!bin/bash
docker pull gerselle/lab6:latest
docker stop apache2
docker system prune -f
docker run -d --name=apache2 gerselle/lab6:latest
