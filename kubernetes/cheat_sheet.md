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
  
## How can I access my service in minikube? 

- `minikube service <SERVICE-NAME> --url`
- get the `<SERVICE-NAME>` via `kubectl get services`

## My service does not work when type is LoadBalandcer

- Use `NodePort` instead
- Minikube does not seem to support `LoadBalancer` https://stackoverflow.com/questions/44110876/kubernetes-service-external-ip-pending

## I need to test my logging system and need log messages

- chentex/random-logger

