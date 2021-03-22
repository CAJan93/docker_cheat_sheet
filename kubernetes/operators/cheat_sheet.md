# Cheat sheet about K8s operators

Information taken from "Kubernetes Operators - Automating the Container Orchestration Platform" by Dobies & Wood. 

Current position: Start of Chapter 3
all we did in chapter 2 was k create -f for all files in /Users/D072532/Downloads/chapters/ch03

## Basics

Operators extend the **control plane** of K8s. They provide an additional endpoint, called a **custom resource**, which extends the Kubernetes API and manages a custom resource definition.

Other resources also have controllers. When we add an operator for a CR, then we just add another controller to the ones that already exist. A CRD is the schema of the CR. 

Usually an operator has a namespace scope, but you can also define cluster scoped operators
    Useful for operators that manage a service mash 

Permissions: 
    You define roles that are a combination of resources (e.g. pods) and attributes (e.g. list)
    You define a rolebinding that connects one or more roles with a user account

An **Operation Lifecycle Manger** deploys and manages and operator on a K8s cluster. Use them to distribute or upgrade operators. OLM defines a **Cluster Service Version**, which defines what an operator can look like. Use **Operator Meetering** to measure the performance of an operator.