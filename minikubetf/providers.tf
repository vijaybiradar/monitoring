terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.26.0"
    }
    minikube = {
      source = "scott-the-programmer/minikube"
      version = "0.3.10"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

provider "minikube" {
  kubernetes_version = "v1.28.3"
}

provider "kubernetes" {
  host = minikube_cluster.docker.host
  client_certificate     = minikube_cluster.docker.client_certificate
  client_key             = minikube_cluster.docker.client_key
  cluster_ca_certificate = minikube_cluster.docker.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host = minikube_cluster.docker.host
    client_certificate     = minikube_cluster.docker.client_certificate
    client_key             = minikube_cluster.docker.client_key
    cluster_ca_certificate = minikube_cluster.docker.cluster_ca_certificate
  }
}