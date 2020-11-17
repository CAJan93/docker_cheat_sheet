# build with buildkit

```bash
DOCKER_BUILDKIT=1 docker build .
```

Buildkit builds multi-stage images in parallel.


Show the ports of running container 1fd4ac820a0f
docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' 1fd4ac820a0f


# get volumes for a container
docker inspect $container | jq '.[].Volumes|to_entries[].key'


from https://gist.github.com/dchapkine/8423980

# Login into running containe
 docker exec -it $CONTAINER_ID bash

# Container stdout

```
docker logs -f $CONTAINER_ID
```

- `-f` follows the logs

# Inspect container config
docker inspect $CONTAINER_ID

# Stop all containers
docker stop $(docker ps -a -q)

# Remove all docker images
 docker rmi $(docker images -a -q)

# Stop and Remove all docker containers
 docker stop $(docker ps -a -q) &&  docker rm $( docker ps -a -q)

# Stop and Remove all docker containers + Remove all docker images
 docker stop $(docker ps -a -q) &&  docker rm $( docker ps -a -q) &&  docker rmi $( docker images -a -q)

# Show all docker containers memory consumption
for line in $(docker ps | awk '{print $1}' | grep -v CONTAINER); do docker ps | grep $line | awk '{printf $NF" "}' && echo $(( $(cat /sys/fs/cgroup/memory/docker/$line*/memory.usage_in_bytes) / 1024 / 1024 ))MB ; done

Remove all docker containers containing 'STRING' in container name.
Replace STRING with the name your are searching for.

docker rm $(docker ps -a -f name=STRING -q)

# remove all untagged images
for img in $(docker image ls | grep \"<none>\" | awk '\"'\"'{ print $3 }'\"'\"' ) ; do docker image rm -f $img ; done


# running a static website
```
docker run --name static-site -e AUTHOR="Your Name" -d -P dockersamples/static-site
```

`--name` gives a name to the running container
`-e` sets an environment variable
`-d` detaches the container from the current terminal
`-P` publishes all ports exposed by the container. Use `docker ps` or `docker port` to see the ports to which ports were exposed
`-p` use this flag to expose a specific port like so `-p <local>:<docker>` exposes port `<docker>` to `localhost:<local>`.


# print the ports of all containers

```
docker ps --format "{{.ID}} {{.Image}} {{.Ports}}"
```

`--format` enables you to do a projection. You can also use `--filter` to apply a selection operation.
Read more on this in the [documentation](https://docs.docker.com/engine/reference/commandline/ps/)

# print all network settings of a container

```
docker inspect 5a26358fbb6f | jq .[0].NetworkSettings
```

# How to share local images via Dockerhub

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

# inspecting volumes

## What volumes are out there? 

```
docker volume ls
```

## Inspect a specific volume

```
docker volume inspect VOLUME
```

- Docker stores the data of the volum in the `Mountpoint`. You can `cd` to this point and inspect the data manually now

## Inspect all volumes 

```
for volume in $(docker volume ls --format "{{.Name}}") ; do echo -e "\n\n$(tput setaf 1)$volume:" && docker volume inspect $volume | jq ; done
```

- command iterates over all volumes and inspects each volume. 
- `$(tput setaf 1)` is used to color the volume name red
- `jq` is used to pretty print JSON

