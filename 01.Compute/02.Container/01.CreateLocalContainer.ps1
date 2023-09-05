<# SDK References:
1. Install Docker          - https://docs.docker.com/desktop/#download-and-install 
2. Install dotnet core sdk - https://dotnet.microsoft.com/download/dotnet-core
#>

#Navigate to folder with Dockerfile and Web App
cd "C:\Projects\Personal\AZ-204\01.Compute\02.Container"

#List contents of the Web App
ls ./webapp

#====================================================================
#STEP 1: Build, test and publish Web App locally
#====================================================================
dotnet build ./webapp

dotnet run --project ./webapp 

curl http://localhost:5000/test #Open a new console window

dotnet publish -c Release ./webapp

#====================================================================
#STEP 2: Build and tag Container defined in Dockerfile
#====================================================================
docker build -t webappimage:v1 .

#Alternative with plain progress
docker build --progress plain -t webappimage:v1 .

#If you already built the image you'll need to delete the image and your build cache so new layers are built
docker rmi webappimage:v1 && docker builder prune --force && docker image prune --force

<# NOTE:
When you use the docker build command to build a Docker image, the resulting image is not stored as a single file in the file system.
Instead, it is composed of multiple layers and metadata, and Docker manages these components internally. 

For Docker Desktop on Windows, images are stored in a virtual machine managed by Docker. You can manage these images using Docker commands, 
but you won't find them in the host file system directly.
#>

#====================================================================
#STEP 3: Run and test Container locally
#====================================================================
docker run --name webapp --publish 8080:80 --detach webappimage:v1

curl http://localhost:8080/test

#Stop and delete the running Web App container
docker stop webapp
docker rm webapp

#List docker images
docker image ls
docker image ls webappimage:v1