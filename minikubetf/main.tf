resource "minikube_cluster" "docker" {
  driver       = "docker"
  cluster_name = "minikube"
  addons = [
    "default-storageclass",
    "storage-provisioner"
  ]
}

resource "kubernetes_namespace" "wickstack" {
  metadata {
    name = "wickstack"
  }
}

resource "helm_release" "grafana" {
  name       = "grafana-release"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "7.3.2"

  values = [
    "${file("grafana-values.yaml")}"
  ]

}