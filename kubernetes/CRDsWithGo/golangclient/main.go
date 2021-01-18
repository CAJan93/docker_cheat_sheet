package main

import (
	"flag"
	"fmt"
	"log"

	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/apimachinery/pkg/runtime/serializer"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"example.com/jm/k8scrd/api/types/v1alpha1"
	clientV1alpha1 "example.com/jm/k8scrd/clientset/v1alpha1"
	"k8s.io/client-go/kubernetes/scheme"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
)

var kubeconfig string

func init() {
	flag.StringVar(&kubeconfig, "kubeconfig", "", "path to Kubernetes config file")
	flag.Parse()
}

func main() {
	var config *rest.Config
	var err error

	if kubeconfig == "" {
		log.Printf("using in-cluster configuration")
		config, err = rest.InClusterConfig()
	} else {
		log.Printf("using configuration from '%s'", kubeconfig)
		config, err = clientcmd.BuildConfigFromFlags("", kubeconfig)
	}

	if err != nil {
		panic(err)
	}

	v1alpha1.AddToScheme(scheme.Scheme)

	crdConfig := *config
	crdConfig.ContentConfig.GroupVersion = &schema.GroupVersion{Group: v1alpha1.GroupName, Version: v1alpha1.GroupVersion}
	crdConfig.APIPath = "/apis"
	crdConfig.NegotiatedSerializer = serializer.NewCodecFactory(scheme.Scheme)
	crdConfig.UserAgent = rest.DefaultKubernetesUserAgent()

	clientSet, err := clientV1alpha1.NewForConfig(config)
	if err != nil {
		panic(err)
	}
	projects, err := clientSet.Projects("default").List(metav1.ListOptions{})
	if err != nil {
		panic(err)
	}

	// TODO watchresources function call here

	// endless loop here

	fmt.Printf("projects found: %+v\n", projects)
}
