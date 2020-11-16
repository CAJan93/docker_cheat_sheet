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
sudo docker exec -it $CONTAINER_ID bash

# Container stdout
sudo docker logs $CONTAINER_ID

# Inspect container config
docker inspect $CONTAINER_ID

# Stop all containers
docker stop $(sudo docker ps -a -q)

# Remove all docker images
sudo docker rmi $(sudo docker images -a -q)

# Stop and Remove all docker containers
sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q)

# Stop and Remove all docker containers + Remove all docker images
sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q) && sudo docker rmi $(sudo docker images -a -q)

# Show all docker containers memory consumption
for line in `docker ps | awk '{print $1}' | grep -v CONTAINER`; do docker ps | grep $line | awk '{printf $NF" "}' && echo $(( `cat /sys/fs/cgroup/memory/docker/$line*/memory.usage_in_bytes` / 1024 / 1024 ))MB ; done
for line in $(docker ps | awk '{print $1}' | grep -v CONTAINER); do docker ps | grep $line | awk '{printf $NF" "}' && echo $(( $(cat /sys/fs/cgroup/memory/docker/$line*/memory.usage_in_bytes) / 1024 / 1024 ))MB ; done

Remove all docker containers containing 'STRING' in container name.
Replace STRING with the name your are searching for.

docker rm $(docker ps -a -f name=STRING -q)

# remove all untagged images
for img in $(docker image ls | grep \"<none>\" | awk '\"'\"'{ print $3 }'\"'\"' ) ; do docker image rm -f $img ; done