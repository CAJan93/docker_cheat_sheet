- [1. Meta](#1-meta)
- [2. Advantages](#2-advantages)
  - [2.1. What are the key advantages of K8s for a dev?](#21-what-are-the-key-advantages-of-k8s-for-a-dev)
  - [2.2. What are the advantages of containers as a dev?](#22-what-are-the-advantages-of-containers-as-a-dev)
- [3. Components](#3-components)
  - [3.1. What are core components of the control plane?](#31-what-are-core-components-of-the-control-plane)
  - [3.2. What are core components of the node? X](#32-what-are-core-components-of-the-node-x)
- [4. Pods](#4-pods)
  - [4.1. What are the basic characteristics of the network within a pod?](#41-what-are-the-basic-characteristics-of-the-network-within-a-pod)
  - [4.2. What is the resource hierarchy in K8s?](#42-what-is-the-resource-hierarchy-in-k8s)
  - [4.3. What is a probe and how do we define it?](#43-what-is-a-probe-and-how-do-we-define-it)
  - [4.4. Why does a pod need labels?](#44-why-does-a-pod-need-labels)
  - [4.5. How can I receive the labels of a resource?](#45-how-can-i-receive-the-labels-of-a-resource)
  - [4.6. How can I receive a resource that has a specific label?](#46-how-can-i-receive-a-resource-that-has-a-specific-label)
  - [4.7. How can I get a history of what happened to my pod?](#47-how-can-i-get-a-history-of-what-happened-to-my-pod)
  - [4.8. How do I save the yaml that was used to create a pod to the pod definition?](#48-how-do-i-save-the-yaml-that-was-used-to-create-a-pod-to-the-pod-definition)
  - [4.9. How do I constrain a pod?](#49-how-do-i-constrain-a-pod)
  - [4.10. How do you check if two pods can talk to each other? X](#410-how-do-you-check-if-two-pods-can-talk-to-each-other-x)
- [5. YAML](#5-yaml)
  - [5.1. What components does YAML consist out of?](#51-what-components-does-yaml-consist-out-of)
  - [5.2. How do you define a hello world starting a pod using yaml?](#52-how-do-you-define-a-hello-world-starting-a-pod-using-yaml)
  - [5.3. How do you validate if a yaml is correct?](#53-how-do-you-validate-if-a-yaml-is-correct)
- [6. ReplicaSets](#6-replicasets)
  - [6.1. What is a ReplicaSet and what is the purpose?](#61-what-is-a-replicaset-and-what-is-the-purpose)
- [7. Deployments](#7-deployments)
  - [7.1. What are the core features and attributes of deployments?](#71-what-are-the-core-features-and-attributes-of-deployments)
  - [7.2. What is a rolling deployment and how to do it?](#72-what-is-a-rolling-deployment-and-how-to-do-it)
- [8. Services](#8-services)
  - [8.1. Core concepts X](#81-core-concepts-x)
  - [8.2. What service types are there?](#82-what-service-types-are-there)
- [9. Storage](#9-storage)
  - [9.1. Why do I need volumes?](#91-why-do-i-need-volumes)
  - [9.2. What is a Volume Mount X](#92-what-is-a-volume-mount-x)
  - [9.3. Example Volume types](#93-example-volume-types)
  - [9.4. What is a PV? X](#94-what-is-a-pv-x)
  - [9.5. What is a storage class?](#95-what-is-a-storage-class)
- [10. Config Maps](#10-config-maps)
  - [10.1. Example ConfigMap yaml](#101-example-configmap-yaml)
  - [10.2. How do you create a configmap?](#102-how-do-you-create-a-configmap)
    - [10.2.1. Use literals](#1021-use-literals)
    - [10.2.2. Use a file to store all data](#1022-use-a-file-to-store-all-data)
    - [10.2.3. Use an environment variable file](#1023-use-an-environment-variable-file)
  - [10.3. How do you consume the config map?](#103-how-do-you-consume-the-config-map)
- [11. Secrets](#11-secrets)
  - [11.1. How do you consume secrets?](#111-how-do-you-consume-secrets)
  - [11.2. How do you cerate a secret?](#112-how-do-you-cerate-a-secret)
- [12. What is a Stateful Sets X](#12-what-is-a-stateful-sets-x)
- [13. Snippets](#13-snippets)
  - [13.1. Enabling the web UI Dashboard](#131-enabling-the-web-ui-dashboard)
  - [13.2. Run a basic hello world](#132-run-a-basic-hello-world)
- [Trouble shooting](#trouble-shooting)

# 1. Meta

All questions are meant for studying
All other headlines are general notes

# 2. Advantages

## 2.1. What are the key advantages of K8s for a dev?

* Service discovery/load balancing
* Storage orchestration
* Automatic rollout/backup
* Self-healing
* Secret and config management
* Horizontal scaling
* Zero-Downtime deployment
* Self healing

## 2.2. What are the advantages of containers as a dev?

* Run multiple versions of the same app at the same time
* Consistent environment

# 3. Components

## 3.1. What are core components of the control plane?

* Store
  * Keep records.
  * Usually ETCD
* Controller Manger
  * Runs the control loop, watching state of cluster
* Scheduler
  * Manages on which nodes pods come up
* API server
  * Interface for use using kubectl

## 3.2. What are core components of the node? X

* Kubelet
  * Talks with master
* Container Runtime
  * For running the container
  * Usually Docker
* Kube-Proxy
  * Ensures that each pod gets unique IP address

# 4. Pods

The basic building block of our cluster. They are the smallest unit in our cluster an can run one or more container. 

## 4.1. What are the basic characteristics of the network within a pod?

* Pod containers share the same IP/port
* Pod containers have the same network interface (localhost)
* Container processes need to bind to different ports within a pod
* Ports can be reused by containers on the same node if containers are in different pods

## 4.2. What is the resource hierarchy in K8s?

```bash
Pod -> replicaSet -> Deployment 
```

## 4.3. What is a probe and how do we define it?

* It uses a probe, which is just a periodic test
* Return statues of probes are: `Success`, `Fail`, `Unknown`.
  * **Liveliness** probe
    * Is the pod healthy?
    * If this fails the container will be restarted (see `restartPolicy`)
    * Example probe: Run command in container and see if it returns 0. 
  * **Readiness** probe
    * Is the pod ready to accept traffic?

Example **Liveliness** probe:

```yaml
apiVersion: v1
kind: Pod
metadata:
    name: mypod
    labels:
        app: someApp
spec: 
    containers:
    - name: mypod
      image: nginx:alpine
      livenessProbe: 
        httpGet:
            path: /index.html
            port: 80
```

## 4.4. Why does a pod need labels?

We use labels to make a pod addressable by a service or a deployment.

## 4.5. How can I receive the labels of a resource?

`k get <resource> <resource-name> --show-labels`

## 4.6. How can I receive a resource that has a specific label?

`k get <resource> -l someLabel=someValue`

## 4.7. How can I get a history of what happened to my pod? 

use `k describe pod <pod-name>` and look at the events.

## 4.8. How do I save the yaml that was used to create a pod to the pod definition?

use `k create <resource> <pod-name> --save-config`. The yaml will be converted to json and added as a annotation to the file. Does work with any kind of resources.

## 4.9. How do I constrain a pod?

In the yaml, I define `spec.resources.limits` and then `memory` or `cpu`.

## 4.10. How do you check if two pods can talk to each other? X

Get the `target-pot-ip` via k get `k get <target-pod> -o yaml`. At the end the `podIP` is listed. If you are using services, you can also use the `cluster-ip` of the service instead of the `podIP`

`k exec <pod> -- curl http://<target-pot-ip>`

# 5. YAML

## 5.1. What components does YAML consist out of? 

maps

```bash
exampleMap:
    key1: value
    key2:
        subKey: value
```

Lists

```bash
aList:
    - map1: value
      map1Prop: value
    - map2: value
      map2Prp: value
```

## 5.2. How do you define a hello world starting a pod using yaml?

```yaml
apiVersion: v1
kind: Pod
metadata:
    name: mypod
    labels:
        app: someApp
spec: 
    containers:
    - name: mypod
      image: nginx:alpine
```

## 5.3. How do you validate if a yaml is correct?

```bash
k create -f <file.yaml> --dry-run=client --validate=true
```

# 6. ReplicaSets

## 6.1. What is a ReplicaSet and what is the purpose? 

* Defines the desired number of pods
* Used by Deployment

# 7. Deployments

## 7.1. What are the core features and attributes of deployments?

* Scales pods via ReplicaSets
* Manages pods via labels
* Use this to do zero downtime upgrades

**Example deployment:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend    # gets its own DNS entry within the K8s cluster
  labels:
    app: myapp      # hook up myapp with all pods that match this
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp    # key value pair label to match pod
  template:
    metadata:
      labels:
        app: myapp  # label needs to match deployment
    spec:
      containers:
      - name: myapppod
        image: nginx:alpine
```

## 7.2. What is a rolling deployment and how to do it? 

Update an existing deployment usually by changing the image. Gradually delete old pods and create new pods and thus shift traffic to new version of the pod. Enables us to do zero-downtime upgrades.

It happens automatically if you use `k apply -f <some-file.yaml>`.



# 8. Services 

## 8.1. Core concepts X

- **Definition:** A service defines a single point of entry for one or more pods.
- **Why do we need services?** cannot rely on an IP of a pod, since pods are ephemeral.
- Relies on labels to route traffic tro the right pod. The pods and the service have the same label
- Services also do load-balancing between pods. 


## 8.2. What service types are there?

- ClusterIP
  - Expose service on a cluster-**internal** IP
  - This is default
  - Only pods/services within cluster can talk to this service
- NodePort
  - Exposes node port to **external** caller
  - Opens a port on the node of the service and the service will then forward the request to the pod
- LoadBalancer
  - **External** IP, acts as load balancer
  - Useful if you combine this with load balancer of cloud provider
- ExternalName
  - **External** name, mapped to DNS service

# 9. Storage

## 9.1. Why do I need volumes? 

- Pods are ephemeral
- Volumes are long-lasting and can store the data for the pod


## 9.2. What is a Volume Mount X

- A Volume Mount refers to a volume by name and defines the `mountPath`.

## 9.3. Example Volume types

- `emptyDir`: Empty dir for storing data in pod, tied to pods lifecycle. Good for sharing data between containers within pod
- `hostPath`: Path on host to persist data
- `NFS`: Mounted path to NFS

## 9.4. What is a PV? X

- A Persistent Volume provided by cloud provider or admin. You need a PVC to be able to access a PV
- PVs are cluster-wide
- This is independent of the pods and also of the node, since it is network-attached storage (NAS)
- K8s takes care of binding the PVC to the PV. The PV relies on the external storage to provide storage
- Order of definitions: setup the PV, setup the PCV, setup the volume

## 9.5. What is a storage class?

- A `StorageClass` is a storage template used for dynamically provisioning PVs
- Storage class workflow: 
  - You define a SC
  - You define a PVC
  - The SC will create a PV and bind to the underlying storage defined in the SC
  - The PCV will bind to the PV and the pod can use the storage


# 10. Config Maps

Store config information cluster-wide and provides to containers.

## 10.1. Example ConfigMap yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata: 
  name: app-settings
  labels:
    app: app-settings
data:
  key: v1
  key.subkey: v2
```

## 10.2. How do you create a configmap? 

Both approaches create slightly different configmaps

### 10.2.1. Use literals

`k create configmap <cm-name> --from-literal=key=value --from-literal=otherKey=otherValue`. 

### 10.2.2. Use a file to store all data

```txt
key=v1
key.subkey=v2
```

You can now use `k create configmap <cm-name> --from-file=</path/to/file/above.txt>`.

### 10.2.3. Use an environment variable file

```txt
key=v1
key.subkey=v2
```

Store this as `<some-name>.env` file. Use `k create configmap <cm-name> --from-env-file=</path/to/file/above.txt>`.


## 10.3. How do you consume the config map?

Config Maps can either be consumed as files or as environment variables. If you consume it as files, Each key that you defined in the cm will be listed as its own file, which contains the value in it.

Examples of consuming a cm as envs:

```yaml
apiVersion: apps/v1
...
spec:
  template:
    ...
  spec:
    containers: ...
    env:
    - name: KEY                 # name of env to which we store value to
      valueFrom:
        configMapKeyRef:
          name: app-settings    # name of the cm created above
          key: key              # key that we look up in the cm
```

To load all data as environment variables using 

```yaml
...
  spec:
  containers:
    envFrom:
    - configMapRef:
      name: app-settings
```

Now, you can access all the env variables that you defined in the config map.



# 11. Secrets

- Secrets are basically Config Maps, but for sensitive data, e.g. passwords
- Data in secrets is not encrypted, it is just base64 encoded
- We use RBAC to decide which pod can read which secret

## 11.1. How do you consume secrets? 

Just like CMs, you can consume secrets as environment variables or as files. This is basically the same process as with config maps.

## 11.2. How do you cerate a secret? 

`k cerate secret generic my-secret --from-literal=key=value`.

Use `k cerate secret tls ...` to create a tls secret.

You can also use yaml to store your secret. Be aware that secrets are only base64 encoded, not encrypted.





# 12. What is a Stateful Sets X

- Provides stateful pod
- has predictable name

# 13. Snippets

## 13.1. Enabling the web UI Dashboard


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


## 13.2. Run a basic hello world 

```basic
k run <pod-name> --image=nginx:alpine
```

Port is running with cluster-ip. Not accessible from the outside.

```basic
k port-forward <pod-name> 8080:80
```

Navigate to `localhost:8080`. 

# Trouble shooting

- `k logs <pod-name>` or `k logs <pod-name> -c <container-name>` to access a container inside a pod
- Use `k describe <pod-name>` to get some basic event information about your pod
- Use `k exec <pod-name> -it sh` to look around the container
- Check if a pod can talk to another pod, by exec into pod, installing curl and saying `curl <pod-ip>` or `curl <service-ip>`


