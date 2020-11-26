https://github.com/kfoozminus/cheatsheets/blob/master/kubernetes.md

Get basic information about the cluster

```
kubectl cluster-info
kubectl cluster-info dump
```

# Tools 

## Stern 

Follow logs from multiple pods in a cluster

Install via 

```
wget https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 && \
    mv stern_linux_amd64 /usr/bin/stern && \
    chmod +x /usr/bin/stern
```

## Squash

Attach a debugger to a running container. See [Example](https://github.com/solo-io/squash)

Install via VS Code.

## Ksync

```
# make sure you are sudo
curl https://ksync.github.io/gimme-that/gimme.sh | sudo bash
```

- Does not work perfectly

## yq

A wrapper for `jq`. You can to select things on a yaml with your terminal

Install via 

```
pip3 install yq
```

## Inlets

Expose a service to the internet. BE CAREFUL ABOUT SECURITY! See [GitHub](https://github.com/inlets/inlets)

Install via 

```
curl -sLS https://get.inlets.dev | sudo sh
```

# FAQ

## Where is my dashboard?

- You may need to forward ports using `kubectl proxy`
- You can reach the dashboard on `http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login`
- Check out the token you need to sign in via `kubectl -n kube-system get secret`. All secrets with type 'kubernetes.io/service-account-token' will allow to log in. Note that they have different privileges.

- If there still is no dashboard, you may need to install it via `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml`. Get token information with `kubectl -n kube-system describe secret <TOKEN_NAME>` e.g. `default-token-gz55s`
- Paste the token part of the token into the login dashboard

## I cannot expose my pod via a service

- Tried to expose via `kubectl expose rc kubia --type=LoadBalancer --name kubia-http` gives `replicationcontrollers "kubia" not found`
- pod `kubia` does not exist. Check existing pods via `kubectl get pods` 

- Try `kubectl expose pod kubia --type=LoadBalancer --name kubia-http` instead
- The load balancer will be listed as a service in the dashboard ar in `kubectl get services`

- https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/#debugging-services

## other things

- List resources of type `kubectl get <RESOURCE>`
- Get basic info about a resource yaml `kubectl explain <RESOURCE>`
- Get yaml of something `kubectl get pod <PODNAME> -o yaml`. See pod names via `kubectl get pods -o wide`
- Forward a port `kubectl port-forward <POD-NAME> 8888:8080`
- List labels of pods `kubectl get po --show-labels`. List a specific label `kubectl get po -L <LABEL-KEY-1> -L <LABEL-KEY-2>`. Keys are case-sensitive
- Add label with `kubectl label po <POD-NAME> <LABEL-NAME>=<LABEL-Value>`. Overwrite label with `kubectl label po <POD-NAME> <LABEL-NAME>=<LABEL-Value> --overwrite`
- Select something specific from a resource description `kubectl get pod kubia-manual -o json | jq .metadata.annotations`. Use `-o json` in combination with `jq`
- What resources are there `kubectl api-resources`
- Delete pods using label `kubectl delete po -l <LABEL-NAME>=<LABEL-Value>`
- Delete all pods in a namespace `kubectl -n <NS> delete po --all`
- Delete everything in a namespace `kubectl -n <NS> delete all --all`
- Filter resource by labels `kubectl get <RESOURCE> --show-labels -L <LABEL-KEY> --selector="<LABEL-KEY>=<LABEL-VAL>"`
- Edit a resource description in place using `nano` `KUBE_EDITOR="nano" kubectl edit <RESOURCE> <RESOURCE-NAME>`
- Scale using a replication controller `kubectl scale rc kubia --replicas=10`

  
## How can I access my service in minikube? 

- `minikube service <SERVICE-NAME> --url`
- get the `<SERVICE-NAME>` via `kubectl get services`

## My service does not work when type is LoadBalandcer

- Use `NodePort` instead
- Minikube does not seem to support `LoadBalancer` [link](https://stackoverflow.com/questions/44110876/kubernetes-service-external-ip-pending)

## I need to test my logging system and need log messages

- chentex/random-logger

## Move namespace

- The below command kinda works...
- `kubectl get all -n <OLD-NS> -o yaml | sed -e 's/namespace: <OLD-NS>/namespace:  <NEW-NS>/' | kubectl apply -f -`
- https://stackoverflow.com/questions/64985461/how-do-i-copy-all-resources-to-a-new-namespace/64985982?noredirect=1#comment114894246_64985982


# Concepts FAQ

## Why do I need labels?

- Labels are kv-pairs
- You can use labels to group resources
- Labels on pods
  - You can use labels to list pods that do not have a label `kubectl get po -l '!<LABEL-NAME>'` 
  - You can use labels to list pods that have a specific label value `kubectl get po -l creation_method=manual`
  - You can isolate pods from a replication controller, by changing their labels so that they do no longer meet the requirement from the rc
- Labels on nodes
  - Attach label to nodes if nodes are heterogenous and you want to specify where pods should be scheduled
  - You can specify that a pod should be scheduled on a specific node via `spec.nodeSelector.<LABEL-KEY>.<LABEL-VAL>`. May leet to pod being unscheduled

## Difference between labels and annotations?

- You are using labels to select/group things
- You are using annotations to provide additional information to users
- You cannot group by annotations

## What is the point of liveliness probes?

- Let's say you have an app. You want to restart it when it does no longer work properly 
- K8s will restart the corresponding pod, if the container in it crashes
- Sometimes the app will crash without the container crashing
- A liveliness probe defines situation when you want to restart the pod, even though its containers are still alive
- Be careful to set a delay to the liveliness probe. Otherwise the app will be presumed to be dead before it started
- If you use a HTTP liveliness probe, make sure it does not require authentication, because it will always fail otherwise
- K8s will retry the probe. You do not have to implement a retry loop yourself

## What does a ReplicationController count? 

- A RC counts the number of pods matching a specific label
- It will make sure that the number of pods with that label is as defined
- If a pod fails the RC will replace it using a template
- This way an RC abstracts from Pods. So if you have an A pod called "frontend" half of those pods might have a specific label, for which an RC is responsible for
  - This also means that a pod is not tied to a RC. If the label changes the pod moves out of the influence of the RC
  - Super helpful if you want to keep production cluster running, while keeping the bad pod around
  - You can do so by changing the pod template in the RC 

## How can I delete a ReplicationController, but keep the pods

- As explained above the RC and the pods are only loosely coupled with the help of labels
- Usually the pods are deleted if the RC is deleted
- You can prevent that by using `kubectl delete rc <RC-NAME> --cascade=false`

## What is the difference between ReplicationControllers and ReplicaSets?

- RCs are the original version in K8s. RSs are the new way to control the number of replicas of a pod
- RSs also support selecting pods that do NOT have a label (see [link](https://github.com/knrt10/kubernetes-basicLearning#using-the-replicasets-more-expressive-label-selectors))
- RS is not part of the v1 api

## How can I run exactly one pod per node? 

- Use a DaemonSet
- DaemonSet vs ReplicaSet: A DS deploys one pod per node. An RS deploys a fixed number of pods on any node that is available

## Why does my DaemonSet not deploy stuff?

- A DS will only deploy on the nodes that match the labels defined in `spec.template.spec.nodeSelector`. 
- Check how your nodes are labeled with `kubectl get nodes --show-labels` or `kubectl get nodes -L <LABEL-KEY>`
- If the label from the `nodeSelector` and the label from the node does not match, nothing will be deployed

## How do I deploy a Pod that does one thing and then exits?

- Use a Job