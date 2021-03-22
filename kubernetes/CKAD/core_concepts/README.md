- [Meta](#meta)
- [Advantages](#advantages)
  - [What are the key advantages of K8s for a dev?](#what-are-the-key-advantages-of-k8s-for-a-dev)
  - [What are the advantages of containers as a dev?](#what-are-the-advantages-of-containers-as-a-dev)
- [Components](#components)
  - [What are core components of the control plane?](#what-are-core-components-of-the-control-plane)
  - [What are core components of the node?](#what-are-core-components-of-the-node)
- [Pods](#pods)
  - [What are the basic characteristics of the network within a pod?](#what-are-the-basic-characteristics-of-the-network-within-a-pod)
  - [What is the resource hierarchy in K8s?](#what-is-the-resource-hierarchy-in-k8s)
- [Snippets](#snippets)
  - [Enabling the web UI Dashboard](#enabling-the-web-ui-dashboard)
  - [Run a basic hello worl](#run-a-basic-hello-worl)

# Meta

All questions are meant for studying
All other headlines are general notes

# Advantages

## What are the key advantages of K8s for a dev?

* Service discovery/load balancing
* Storage orchestration
* Automatic rollout/backup
* Self-healing
* Secret and config management
* Horizontal scaling
* Zero-Downtime deployment
* Self healing

## What are the advantages of containers as a dev?

* Run multiple versions of the same app at the same time
* Consistent environment
* Ship software faster

# Components

## What are core components of the control plane?

* Store
  * Keep records.
  * Usually ETCD
* Controller Manger
  * Runs the control loop, watching state of cluster
* Scheduler
  * Manages on which nodes pods come up
* API server
  * Interface for use using kubectl

## What are core components of the node?

* Kubelet
  * Talks with master
* Container Runtime
  * For running the container
  * Usually Docker
* Kube-Proxy
  * Ensures that each pod gets unique IP address

# Pods

The basic building block of our cluster. They are the smallest unit in our cluster an can run one or more container. 

## What are the basic characteristics of the network within a pod?

* Pod containers share the same IP/port
* Pod containers have the same network interface (localhost)
* Container processes need to bind to different ports within a pod
* Ports can be reused by containers on the same node if containers are in different pods

## What is the resource hierarchy in K8s?

```bash
pod -> deployment
```

# Snippets

## Enabling the web UI Dashboard


Check out the [documentation](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
k describe secret -n kube-system > tmp.yaml
head -n 50 tmp.yaml
```

Get the `service-account-token` from `tmp.yaml`. Copy the token.

```bash
k proxy --accept-hosts='.*'
```

Navigate to `http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`


## Run a basic hello worl 

```basic
k run <pod-name> --image=nginx:alpine
```

Port is running with cluster-ip. Not accessible from the outside.

```basic
k port-forward <pod-name> 8080:80
```

Navigate to `localhost:8080`. 
