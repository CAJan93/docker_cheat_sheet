- [1. Storage](#1-storage)
  - [1.1. K8s Persistent Volume system](#11-k8s-persistent-volume-system)
  - [1.2. Container Storage Interface (CSI)](#12-container-storage-interface-csi)
  - [1.3. Deleting a PVC](#13-deleting-a-pvc)
  - [1.4. Dynamic provisioning](#14-dynamic-provisioning)
  - [1.5. Block and File Systems](#15-block-and-file-systems)
  - [1.6. Cloned volumes](#16-cloned-volumes)
- [2. Mutli-container pods](#2-mutli-container-pods)
  - [2.1. Why do we not just deploy containers in K8s? Why pods? X](#21-why-do-we-not-just-deploy-containers-in-k8s-why-pods-x)
  - [2.2. How do you get information about a yaml resource field?](#22-how-do-you-get-information-about-a-yaml-resource-field)
  - [2.3. Init Pattern](#23-init-pattern)
  - [2.4. Sidecar Pattern](#24-sidecar-pattern)
    - [2.4.1. Adapter Pattern](#241-adapter-pattern)
    - [2.4.2. Ambassador Pattern](#242-ambassador-pattern)
- [3. Security](#3-security)
  - [3.1. Authenticating humans vs. machines X](#31-authenticating-humans-vs-machines-x)
  - [3.2. What is the image pull secret?](#32-what-is-the-image-pull-secret)
  - [3.3. You need RBAC to specify your own service account X](#33-you-need-rbac-to-specify-your-own-service-account-x)

[Training repository](https://github.com/nigelpoulton/ps-vols-and-pods)


# 1. Storage
## 1.1. K8s Persistent Volume system

- K8s has plugin for storage
  - Every storage system that wants to get used by K8s needs a plugin for K8s
- K8s uses objects to manage storage
  - Persistent volume is used to map external storage to K8s storage 
  - PV is used by pod via PVC
  - Once a pod claims a PV using a PVC, no other pod can use the PV.
    - All contains within the pod can use the PV
    - Also see `accessMode`
- PV: 1-to-1 mapping to actual storage 
- PCV: Gets you the PV
- StorageClass: Type of PV that gets created automatically on demand

## 1.2. Container Storage Interface (CSI)

- Storage used to be "in-tree" (storage system access was inside K8s code base)
  - Pro: easy at beginning
  - Cons: shitty, because K8s people has to maintain storage code
- Solution: CSI
  - Not specific to K8s
    - See [K8s CSI implementation](https://github.com/kubernetes-csi)
  - CSI is a definition how to create plugins for ANY container orchestrator


## 1.3. Deleting a PVC

- If do not need a PV anymore, you can delete the PVC. Depending on your `persistentVolumeReclaimPolicy` the data in the PV will be `retain`ed or `delete`d.


## 1.4. Dynamic provisioning

- Create volumes automatically 
- Create different types/classes of volumes
- The Storage class (sc) operator will create volumes on demand
- SC are immutable objects. If you want to change them you have to delete and recreate them

## 1.5. Block and File Systems

- raw block volume 
  - Like unformatted disk drive/raw device
  - Used e.g. by DB to skip file system for speed up and more control
- Mount a file system
  - A fs


## 1.6. Cloned volumes

- cloned volumes
  - Replicates a volume
  - This is an independent volume in the backend that has its own PCV


# 2. Mutli-container pods

- Goal: Keep your main container clean and do all the other stuff simple


## 2.1. Why do we not just deploy containers in K8s? Why pods? X

- If you wrap containers in pods, you can indirectly give your containers extra stuff, like probes or affinities
- All contains in the same pod are scheduled on the same node
- Both containers in the same pod share the same network interface (localhost)
- Pods can directly talk to each other in a pod
- Containers in same pod share same execution environment

## 2.2. How do you get information about a yaml resource field?

- `k explain <resource>.path.to.field`
- E.g.: `k explain pods.metadata.resourceVersion`



## 2.3. Init Pattern

- Prepairs environment for your main container
  - e.g. init container clones git content to a volume. The main container then processes that content
  - Or an init container that waits for an API to be up
- Special container that K8s guarantees will start before next init container OR main container. 
  - K8s also guarantees that init container will run only once
- `spec.initContainers` is an array of containers that will run container in that order
- Request and limits 
  - Limits are calculated by K8s as the sum of the limits from all the non-init containers + the max limits from the init containers
  - This is because the init containers do not run in parallel


## 2.4. Sidecar Pattern

- One main pod with one or more helper pods
- The helper pods could do stuff like format and send logs to a central location
- Sidecar container starts with app container and runs concurrently to it
- Service mash
  - The sidecar container encrypts traffic between pods (and more)
  


### 2.4.1. Adapter Pattern

- A sidecar pattern
- Helper takes non-standard formatted output from main container and rewrites it to some standard format
- Example: You could use the adapter pattern to make metrics readable by prometheus
- Since both pods share the same network interface you can just communicate over localhost 
  - Example: Main container exposes metrics at `localhost:main/metrics/`. Adapter container takes those metrics from localhost, processes them and exposes the processed metrics at `localhost:metrics/`

### 2.4.2. Ambassador Pattern

- A sidecar pattern
- Proxies connection of main container to outside world
  - Advantage: Main app is simple. It does not need to know how to handle connections to other apps
  - This is like a service-discovery layer
- Again communication between containers via shared network interface. 
  - Main container talks to `localhost:xyz`, ambassador listens on `localhost:xyz` and does the connection to the outside world


# 3. Security

- Permissions of apps to K8s via authentication and authorization using service accounts
- Give pods minimum of permissions: Tradeoffs less permissions, the harder work becomes

## 3.1. Authenticating humans vs. machines X

- Users authenticate with user accounts
- Applications authenticate with service accounts
  - Service accounts attach to pods. SA are user accounts for pods
- Every command against K8s uses the api server. The api server authenticates using the certificates that are provided. K8s now knows that the request is coming from a user who is who he claims. K8s now checks authorization of that user/service accounts.
- If a container makes a request against the K8s api server, it passes along its token. The api server can now authenticate and authorize the request
- service account is listed in `pod` under `spec.serviceAccount`. Default value is value of namespace
- `k get serviceaccount`. Service account yaml lists a secret which contains the token used for authentication/authorization
- Inside the pod, the service information is listed in `ls /var/run/secrets/kubernetes.io/serviceaccount/`
- Multiple pods can share the same service account
- service accounts are namespaced. Each namespace has its own default 

## 3.2. What is the image pull secret?

The service account also lists an `image pull secret`, which contains secrets to pull images from private repositories

## 3.3. You need RBAC to specify your own service account X

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default  # roles are namespaced
  name: svc-ro
rules:    # can get/watch/list services. Everything else is denied
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "watch", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding # bind roles to service account
metadata:
  name: svc-ro
  namespace: default
subjects:
- kind: ServiceAccount
  name: "service-reader"
  namespace: default
roleRef:
  kind: Role 
  name: svc-ro 
  apiGroup: rbac.authorization.k8s.io
```

- Bind the ability to list pods to the service account `service-reader`.
- `k get role <ROLE-NAME>`
- Get other bindings with `k get clusterrolebindings`
  - Be aware that `minikube` has custom crb that disables rbac
  - Remove it by deleting the minikube crb
- For the above example, create the required service account using `k create  serviceaccount service-reader`
- In a `pod` you can now set `spec.serviceAccountName` 