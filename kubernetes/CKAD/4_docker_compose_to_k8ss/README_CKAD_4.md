- [](#)
- [1. Mapping Docker Compose to Kubernetes](#1-mapping-docker-compose-to-kubernetes)
- [2. Docker stacks](#2-docker-stacks)
- [3. Converting with Kompose](#3-converting-with-kompose)
- [4. Working with Skaffold](#4-working-with-skaffold)

# 1. Docker-compose basics

- **Purpose:** Define and run multi container applications
- Uses `docker-compose.yaml` to describe services
- Uses `networks` to communicate between containers
  - Different from K8s, where you do not have to manually define the networks used, but use services for communication

## Why use K8s instead of Docker Compose?

- K8s is better for a production situation. Docker compose is more for development
- If a container crashes this is a problem in docker compose, but no problem in K8s


# 2. Mapping Docker Compose to Kubernetes 



# 3. Docker stacks


# 4. Converting with Kompose 


# 5. Working with Skaffold

- Uses Kompose under the hood
