- [1. Docker-compose basics](#1-docker-compose-basics)
  - [1.1. Why use K8s instead of Docker Compose?](#11-why-use-k8s-instead-of-docker-compose)
- [2. Mapping Docker Compose to Kubernetes](#2-mapping-docker-compose-to-kubernetes)
- [3. Docker stacks](#3-docker-stacks)
  - [3.1. Why? X](#31-why-x)
  - [3.2. What are docker stack commands? X](#32-what-are-docker-stack-commands-x)
  - [3.3. Try this with example (does not fully work)](#33-try-this-with-example-does-not-fully-work)
- [4. Converting with Kompose](#4-converting-with-kompose)
  - [4.1. Why? X](#41-why-x)
  - [4.2. Example](#42-example)
- [5. Working with Skaffold](#5-working-with-skaffold)
  - [5.1. What is Skaffold and Why? X](#51-what-is-skaffold-and-why-x)
  - [5.2. Some useful commands for docker-compose to k8s](#52-some-useful-commands-for-docker-compose-to-k8s)


# 1. Docker-compose basics

- **Purpose:** Define and run multi container applications
- Uses `docker-compose.yaml` to describe services
- Uses `networks` to communicate between containers
  - Different from K8s, where you do not have to manually define the networks used, but use services for communication

## 1.1. Why use K8s instead of Docker Compose?

- K8s is better for a production situation. Docker compose is more for development
- If a container crashes this is a problem in docker compose, but no problem in K8s


# 2. Mapping Docker Compose to Kubernetes 

- In general you would split up one docker compose file to many k8s files
- `nodes.container_name,image,ports` -> deployment
- `nodes.volumes` -> storage
- `nodes.env_fil` -> ConfigMaps
- `nodes.networking` and `networks` -> Services
- A docker compose service is different from a K8s service. A docker compose service is about the pods, storage and configs, K8s service is about networking

# 3. Docker stacks

## 3.1. Why? X

- Docker stack commands are a good way to deploy existing docker compose files to K8s without having to translate them first

## 3.2. What are docker stack commands? X

- Commands for swarm mode
- Allow you to deploy docker on a cluster (swarm mode)
- Docker swarm aka. swarm mode: Basically K8s, but from docker
- docker stack commands are used to run commands against swarm mode or to translate docker compose file to k8s resources
  
## 3.3. Try this with example (does not fully work) 

- get example from [github](https://github.com/dockersamples/example-voting-app)
- `docker-compose build`
- `docker-compose up`
- visit [http://localhost:5000](http://localhost:5000)
- Check docker stuff with `docker ps`
- `docker-compose down && docker ps`
- Now let's try in combination with K8s
- `docker stack deploy -c docker-compose.yml myapp`
- Unfortunately this does not work, since you need at least a compose file with version 3. This is version 1 :(
- `docker stack ls` to see the services
- `k get all` to see the k8s resources that were deployed from the docker compose file
- `docker stack ls` to list our docker stack (the deployed application)
- `docker stack rm <my-stack>` to remove the stack



# 4. Converting with Kompose

## 4.1. Why? X

- Translating docker compose files to K8s files
- More serious migration then docker stacks, which is just for trying K8s a bit
- Kompose will create K8s services and deployments by defaults
- Kompose will also create PVs and PVCs

##  4.2. Example

- get example from [github](https://github.com/dockersamples/example-voting-app)
- `mkdir output && kompose convert -f docker-compose-k8s.yml --out ./output`
  - This will write the k8s files to the output folder
- Now `k apply` everything in the output folder

# 5. Working with Skaffold

## 5.1. What is Skaffold and Why? X

- Uses Kompose under the hood
- Used for local K8s development
  - E.g. It will redeploy code if you change it in your setup, by automatically building your artifacts


## 5.2. Some useful commands for docker-compose to k8s

- `skaffold init --compose-file docker-compose.yaml`
- Safe skaffold.yaml file
- `skaffold run` to deploy build and deploy it 
- `skaffold dev` to retrigger build and deploy on code change
- 