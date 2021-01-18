# CRD + Golang

Following [tutorial](https://www.martin-helmich.de/en/blog/kubernetes-crd-client.html) about combining controlling resource definitions with go code.

## Create your custom resource

Custom resource is defined in `crd.yaml`

You can deploy an example via `aproject.yaml`

## Create golang client

`mkdir golangclient && cd golangclient`
Create module with `go mod init example.com/jm/k8scrd`
Get libs via `go get k8s.io/client-go@v0.17.0 && go get k8s.io/apimachinery@v0.17.0`
Organize go code by version, like so `api/types/v1alpha1/project.go`
Folder contains the types that we want to use with the K8s api (`Project` and `ProjectList`)

we use `go get -u github.com/kubernetes-sigs/controller-tools/cmd/controller-gen`tool to generate the methods required by the `object` interface for us (see `project.go`) for `Project` and `ProjectList`.

We use `register.go` to communicate with the client library.

We are using our custom resources in `main.go`

To make things more typesafe, we define our own interface in `using.go` and 

We define interfaces in `projects.go`, which we use in `using.go`

Operator logic: Operator uses `List` to list object and `Watch` to watch changes to our CRDs. This is basically what the `informer` does. `WatchResource`is our reconcile function


