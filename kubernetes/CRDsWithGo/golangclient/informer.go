package main

import (
	"time"

	"example.com/jm/k8scrd/api/types/v1alpha1"
	client_v1alpha1 "example.com/jm/k8scrd/clientset/v1alpha1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/util/wait"
	"k8s.io/apimachinery/pkg/watch"
	"k8s.io/client-go/tools/cache"
)

func WatchResources(clientSet client_v1alpha1.ExampleV1Alpha1Interface) cache.Store {
	// controller controls List and Watch calls and fills
	// store with the new, observed state
	projectStore, projectController := cache.NewInformer(
		&cache.ListWatch{
			ListFunc: func(lo metav1.ListOptions) (result runtime.Object, err error) {
				return clientSet.Projects("default").List(lo)
			},
			WatchFunc: func(lo metav1.ListOptions) (watch.Interface, error) {
				return clientSet.Projects("default").Watch(lo)
			},
		},
		&v1alpha1.Project{},
		30*time.Second,
		cache.ResourceEventHandlerFuncs{
			// TODO functions here
		},
	)

	go projectController.Run(wait.NeverStop)
	return projectStore
}