- [1. Storage](#1-storage)
  - [1.1. K8s Persistent Volume system](#11-k8s-persistent-volume-system)
  - [1.2. Container Storage Interface (CSI)](#12-container-storage-interface-csi)
  - [1.3. Other notes](#13-other-notes)
  - [1.4. Dynamic provisioning](#14-dynamic-provisioning)
  - [1.5. Block and File Systems](#15-block-and-file-systems)
  - [1.6. Cloned volumes](#16-cloned-volumes)
- [2. Mutli-container pods](#2-mutli-container-pods)
  - [2.1. Why do we not just deploy containers in K8s? Why pods?](#21-why-do-we-not-just-deploy-containers-in-k8s-why-pods)
  - [2.2. How do you get information about a yaml resource field?](#22-how-do-you-get-information-about-a-yaml-resource-field)
  - [2.3. Init Pattern](#23-init-pattern)
  - [2.4. Sidecar Pattern](#24-sidecar-pattern)
    - [2.4.1. Adapter Pattern](#241-adapter-pattern)
    - [2.4.2. Ambassador Pattern](#242-ambassador-pattern)

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
- StorageClass: 

## 1.2. Container Storage Interface (CSI)

- Storage used to be "in-tree" (storage system access was inside K8s code base)
  - Pro: easy at beginning
  - Cons: shitty, because K8s people has to maintain storage code
- Solution: CSI
  - Not specific to K8s
    - See [K8s CSI implementation](https://github.com/kubernetes-csi)
  - CSI is a definition how to create plugins for ANY container orchestrator


## 1.3. Other notes

- If do not need a PV anymore, you can delete the PVC. Depending on your `persistentVolumeReclaimPolicy` the data in the PV will be `retain`ed or `delete`ed.


## 1.4. Dynamic provisioning

- Create volumes automatically 
- Create different types/classes of volumes
- The Storage class (sc) operator will create volumes on demand
- SC are immutable objects. If you want to change them you have to delete and recreate them


continue here https://app.pluralsight.com/course-player?clipId=8c65d999-363f-4bb2-a3ef-a584d4ab068f

- Block devices vs. file systems???

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


## 2.1. Why do we not just deploy containers in K8s? Why pods?

- If you wrap containers in pods, you can indirectly give your containers extra stuff, like probes or affinities
- All contains in the same pod are scheduled on the same node
- Both containers in the same pod share the same network interface(localhost)
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
- So you could use the adapter pattern to make metrics readable by prometheus
- Since both pods share the same network interface you can just communicate over localhost 
  - Example: Main container exposes metrics at `localhost:main/metrics/`. Adapter container takes those metrics from localhost, processes them and exposes the processed metrics at `localhost:metrics/`

### 2.4.2. Ambassador Pattern

- A sidecar pattern
- Proxies connection of main container to outside world
  - Advantage: Main app is simple. It does not need to know how to handle connections to other apps
  - This is like a service-discovery layer
- Again communication between containers via shared network interface. 
  - Main container talks to `localhost:xyz`, ambassador listens on `localhost:xyz` and does the connection to the outside world