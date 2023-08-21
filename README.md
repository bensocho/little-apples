This is my 'little apples' app, a small python webapp that uses a MongoDB database. 
The app is containerized with custom images that are located in a public Docker Hub repo.

THE APP CLOUD ARCHITECTURE:
  The terraform scripts will build a vpc with a cidr block of 10.20.0.0/16 in AWS region us-east-1, an application load balancer listening on the public subnets of this 
  vpc,  an auto scaling group, an AWS ECS cluster, with a service running 2 tasks from a task definition family in the private subnets of the vpc where each task runs the 2 
  containers for the app - one for the flask server and one for the MongoDB server. The terraform script will also create the appropriate security groups and route tables.
  
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
- the script will output the alb dns address, copy it and in your browser navigate to that address and you will be in one of the ECS tasks that is running the app.
