## Build docker image
     docker pull docker.io/alpine
     docker build --tag harvester .
## Run container
     docker run -it harvester


## Troubleshooting
If you see error like
     **error creating overlay mount to /var/lib/docker/overlay2/...: invalid argument.**
try to update kernel
