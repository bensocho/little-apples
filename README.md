This is my 'little apples' app, a small python webapp that uses a MongoDB database. 
The app is containerized with custom images that are located in a public Docker Hub repo.
TO RUN THE APP LOCALLY:
- clone the repo to your local machine.
- make sure that you have docker and docker-compose installed. if not follow: https://docs.docker.com/engine/install/ and https://docs.docker.com/compose/install/
- navigate to the cloned directory 
- run docker compose up
- go to http://localhost:80 

TO RUN THE APP IN THE CLOUD:
- you will need terraform installed: https://developer.hashicorp.com/terraform/downloads
- you will need an AWS account and an access key id and secret access key
- clone the repo to your local machine.
- navigate to the cloned directory 
- run ./provision.sh
- enter your AWS access key id and secret access key when prompted and wait for the build to be complete.
