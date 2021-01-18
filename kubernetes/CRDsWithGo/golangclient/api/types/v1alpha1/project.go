package v1alpha1

// metav1 contains metadata properties
import metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

type ProjectSpec struct {
	Replicas int `json:"replicas"`
}

//go:generate controller-gen object paths=$GOFILE
// generate statement that uses controller-gen tool to
// generate runtime.object interface

// Project and ProjectList are being served by K8s API
// They need to implement the runtime.Object interface
// 	see https://pkg.go.dev/k8s.io/apimachinery@v0.20.2/pkg/runtime#Object
//  we define them in deepcopy.go

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
type Project struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec ProjectSpec `json:"spec"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
type ProjectList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`

	Items []Project `json:"items"`
}
