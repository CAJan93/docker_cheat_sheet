# Helpful Docker commands

This site lists a few helpful docker commands. If you are using VS Code you can also use these commands via `Tasks`. 

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



## running a static website
```
docker run --name static-site -e AUTHOR="Your Name" -d -P dockersamples/static-site
```

- `--name` gives a name to the running container
- `-e` sets an environment variable
- `-d` detaches the container from the current terminal
- `-P` publishes all ports exposed by the container. Use `docker ps` or `docker port` to see the ports to which ports were exposed
- `-p` use this flag to expose a specific port like so `-p <local>:<docker>` exposes port `<docker>` to `localhost:<local>`.



## inspecting volumes

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

