# Helpful Docker commands

This site lists a few helpful docker commands. If you are using VS Code you can also use these commands via `Tasks`. Some commands taken from [docker-cheat-sheet](https://github.com/wsargent/docker-cheat-sheet#images)


## Building and managing containers

### Build with buildkit

```bash
DOCKER_BUILDKIT=1 docker build .
```

Buildkit builds multi-stage images in parallel.

### Stop all containers

```
docker stop $(docker ps -a -q)
```

### Remove all docker images

```
docker rmi $(docker images -a -q)
```

### Remove all docker containers containing 'STRING' in container name.

```
docker rm  -f $(docker ps -a -f name=STRING -q)
```

### remove all untagged images

```
for img in $(docker image ls | grep \"<none>\" | awk '\"'\"'{ print $3 }'\"'\"' ) ; do docker image rm -f $img ; done
```

### Import a container as an image from file

```
cat my_container.tar.gz | docker import - my_image:my_tag
```

### Export an existing container

```
docker export my_container | gzip > my_container.tar.gz
```

## Network

### List all docker networks

```
echo -e "ID,Name,Driver,Scope\n$(docker network ls --format "{{.ID}},{{.Name}},{{.Driver}},{{.Scope}}")" | tty-table
```

- `tty-table` used to pretty print this

### Print settings of a specific network

```
docker network inspect <NETWORK_ID>
```

### Run a container in a network

```
docker run --network <NETWORK_NAME> --network-alias mysql  mysql:5.7
```

- `--network` the network in which the container runs
- `--network-alias` an alias for the container that is based on `mysql:5.7`, scoped within the network `<NETWORK_NAME>`


### Debug network problems

```
docker run -it --network <NETWORK_NAME> nicolaka/netshoot
```

- Interactively use this to debug network issues. Learn more on [GitHub page](https://github.com/nicolaka/netshoot)
- run `docker run  --network <NETWORK_NAME> nicolaka/netshoot netstat` to get information about the network config and activity
- run `docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nicolaka/netshoot ctop` to monitor container metrics in real time
- run `docker run --network <NETWORK_NAME> nicolaka/netshoot dig <CONTAINER_ID>` to see if that container is reachable form this network


### print the ports of all containers

```
docker ps --format "{{.ID}} {{.Image}} {{.Ports}}"
```

- `--format` enables you to do a projection. You can also use 
- `--filter` to apply a selection operation.
Read more on this in the [documentation](https://docs.docker.com/engine/reference/commandline/ps/)

### print all network settings of a container

```
docker inspect <CONTAINER_ID> | jq .[0].NetworkSettings
```


## Debugging

### Docker status in pretty

```
echo -e "ID,Image,Ports,Status\n$(docker ps --format "{{.ID}},{{.Image}},{{.Ports}},{{.Status}}")"  | tty-table
```

- `tty-table` displays this in pretty. Install it using `sudo apt-get install -y nodejs && sudo npm i -g tty-table`
- `--format` does projection operations

### Login into running container

```
docker exec -it <CONTAINER_ID> bash
```

- Interactively execute bash in container with id <CONTAINER_ID> 

### Container log stdout

```
docker logs -f <CONTAINER_ID>
```

- `-f` follows the logs

```
docker logs --tail 10 
```

- list the last 10 lines of the logs

### Inspect container config

```
docker inspect <CONTAINER_ID>
```

### Get environment variables of image

```
docker run --rm <IMAGE> env
```

## running a static website
```
docker run --name static-site -e AUTHOR="Your Name" -d -P dockersamples/static-site
```

- `--name` gives a name to the running container
- `-e` sets an environment variable
- `-d` detaches the container from the current terminal
- `-P` publishes all ports exposed by the container. Use `docker ps` or `docker port` to see the ports to which ports were exposed
- `-p` use this flag to expose a specific port like so `-p <hostport>:<containerport>` exposes port `<containerport>` to `localhost:<hostport>`.




## Share local images via Dockerhub

- Go to [Dockerhub](https://hub.docker.com/)
- Create a new, public repository
- Go back to your local machine and run `docker image ls`. The output will look like this

```
REPOSITORY                                      TAG                 IMAGE ID            CREATED             SIZE
my-app                                          latest              49fd95493a7b        13 minutes ago      171MB
<none>                                          <none>              a4131b2a3abb        15 minutes ago      171MB
...
```

- Run `docker tag my-app YOUR-USER-NAME/my-app` and make sure to use your dockerhub user name
- `docker image ls` 
  
```
REPOSITORY                                      TAG                 IMAGE ID            CREATED             SIZE
YOUR-USER-NAME/my-app                           latest              49fd95493a7b        13 minutes ago      171MB
my-app                                          latest              49fd95493a7b        13 minutes ago      171MB
<none>                                          <none>              a4131b2a3abb        15 minutes ago      171MB
...
```

- Run `docker push YOUR-USER-NAME/my-app`. 
- You can now pull the image on a different machine via `docker pull YOUR-USER-NAME/my-app`

## Volumes

### What volumes are out there? 

```
docker volume ls
```

### Inspect a specific volume

```
docker volume inspect <VOLUME_ID>
```

- Docker stores the data of the volum in the `Mountpoint`. You can `cd` to this point and inspect the data manually now

### Inspect all volumes 

```
for volume in $(docker volume ls --format "{{.Name}}") ; do echo -e "\n\n$(tput setaf 1)$volume:" && docker volume inspect $volume | jq ; done
```

- command iterates over all volumes and inspects each volume. 
- `$(tput setaf 1)` is used to color the volume name red
- `jq` is used to pretty print JSON

### Volumes background


| |	Named Volumes |	Bind Mounts |
|----------|----------|----------|
|Host  Location |	Docker chooses	| You control |
|Mount Example (using -v) |	my-volume:/usr/local/data |	/path/to/data:/usr/local/data |
| Populates new volume with container contents |	Yes	 | No |
| Supports Volume Drivers |	Yes |	No |

[About Storage drivers](https://docs.docker.com/storage/storagedriver/): 
- Each command in a Dockerfile creates a new layer
- You can view the layers of an image using `docker history <IMAGE_ID>`
- After layer creation, a layer is locked an can no longer be changed
- When a container is created from an image, it has a thin read/write layer where your application lives, called **container layer**
- This layer is deleted when the container exits
- A **storage driver** manages how the container layer stores data
- Sidenote: If you intend to write lots of data and to persist it, use **volumes**
- Storage drivers differ in performance characteristics. See the [documentation](https://docs.docker.com/storage/storagedriver/select-storage-driver/): 
- View content of **named volumes** via `sudo ls /var/lib/docker/volumes`. Chose volume and use `cat` to examine 
- You can also list volumes via `docker volume ls` and inspect them via `docker volume inspect <VOLUME_ID>`


## Docker compose

- Manages multiple containers using a config yaml
- Also see `DockerCompose/`
- Use `docker-compose up` to start your application
- Use `docker-compose down` to shut down your containers. Pass `--volume` flag to also delete the volumes

## Dockerfile basics


### Instructions

* [.dockerignore](https://docs.docker.com/engine/reference/builder/#dockerignore-file)
* [FROM](https://docs.docker.com/engine/reference/builder/#from) Sets the Base Image for subsequent instructions.
* [MAINTAINER (deprecated - use LABEL instead)](https://docs.docker.com/engine/reference/builder/#maintainer-deprecated) Set the Author field of the generated images.
* [RUN](https://docs.docker.com/engine/reference/builder/#run) execute any commands in a new layer on top of the current image and commit the results.
* [CMD](https://docs.docker.com/engine/reference/builder/#cmd) provide defaults for an executing container.
* [EXPOSE](https://docs.docker.com/engine/reference/builder/#expose) informs Docker that the container listens on the specified network ports at runtime.  NOTE: does not actually make ports accessible.
* [ENV](https://docs.docker.com/engine/reference/builder/#env) sets environment variable.
* [ADD](https://docs.docker.com/engine/reference/builder/#add) copies new files, directories or remote file to container.  Invalidates caches. Avoid `ADD` and use `COPY` instead.
* [COPY](https://docs.docker.com/engine/reference/builder/#copy) copies new files or directories to container.  By default this copies as root regardless of the USER/WORKDIR settings.  Use `--chown=<user>:<group>` to give ownership to another user/group.  (Same for `ADD`.)
* [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint) configures a container that will run as an executable.
* [VOLUME](https://docs.docker.com/engine/reference/builder/#volume) creates a mount point for externally mounted volumes or other containers.
* [USER](https://docs.docker.com/engine/reference/builder/#user) sets the user name for following RUN / CMD / ENTRYPOINT commands.
* [WORKDIR](https://docs.docker.com/engine/reference/builder/#workdir) sets the working directory.
* [ARG](https://docs.docker.com/engine/reference/builder/#arg) defines a build-time variable.
* [ONBUILD](https://docs.docker.com/engine/reference/builder/#onbuild) adds a trigger instruction when the image is used as the base for another build. Instruction will run after the child base finished building.
* [STOPSIGNAL](https://docs.docker.com/engine/reference/builder/#stopsignal) sets the system call signal that will be sent to the container to exit.
* [LABEL](https://docs.docker.com/config/labels-custom-metadata/) apply key/value metadata to your images, containers, or daemons.
* [SHELL](https://docs.docker.com/engine/reference/builder/#shell) override default shell is used by docker to run commands.
* [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#healthcheck) tells docker how to test a container to check that it is still working.


## FAQs

### My entrypoint script gives me `standard_init_linux.go:211: exec user process caused "exec format error"`

- Linux does not know how to execute that file
- Add a `#!/bin/bash` to the top of the file

### My entrypoint script gives me `permission denied`

- Run `ls -la <PATH_TO_SCRIPT>` on the host machine
- If the execution permission is missing add it via `chmod +x <PATH_TO_SCRIPT>`

### Why can I not connect to docker daemon/why do I need sudo to run docker? 

- see [StackOverflow](https://stackoverflow.com/questions/21871479/docker-cant-connect-to-docker-daemon)
- tldr: 

```bash
# create docker group
sudo groupadd docker
# Add the user to the docker group.
sudo usermod -aG docker $(whoami)
# Log out and log back in to ensure docker runs with correct permissions.
# Start docker.
sudo service docker start
```