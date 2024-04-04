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
  namespace  = kubernetes_namespace.wickstack.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "7.3.7"

  values = [
    "${file("helmvalues/grafana-values.yaml")}"
  ]
}

resource "helm_release" "prometheus" {
  name       = "prometheus-release"
  namespace  = kubernetes_namespace.wickstack.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.19.0"

  values = [
    "${file("helmvalues/prometheus-values.yaml")}"
  ]
}

resource "kubernetes_deployment" "ubuntu1" {
    metadata {
        name = "ubuntu1"
        namespace = kubernetes_namespace.wickstack.metadata.0.name
    }
    spec {
        replicas = 1
        selector {
            match_labels = {
                app = "ubuntu1"
            }
        }
        template {
            metadata {
                labels = {
                    app = "ubuntu1"
                }
            }
            spec {
                container {
                    image = "ubuntu:noble-20240225"
                    name = "ubuntu1"
                    port {
                        container_port = 9100
                    }
                    command = [
                    "/bin/sh",
                    "-c",
                    "apt-get update && apt-get install -y wget && wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-arm64.tar.gz && tar xvfz node_exporter-1.2.2.linux-arm64.tar.gz && ./node_exporter-1.2.2.linux-arm64/node_exporter & sleep infinity"
                    ]
                
                  liveness_probe {
                    exec {
                      command = ["bash", "-c", "ps aux"]
                    }
                    initial_delay_seconds = 30
                    period_seconds        = 10
                  }

                  readiness_probe {
                    exec {
                      command = ["bash", "-c", "ps aux"]
                    }
                    initial_delay_seconds = 5
                    period_seconds        = 10
                  }
                }
            }
        }
    }
}



resource "kubernetes_service" "ubuntu1_exporter" {
    metadata {
        name = "ubuntu1exporter"
        namespace = kubernetes_namespace.wickstack.metadata.0.name
    }
    spec {
        selector = {
            app = kubernetes_deployment.ubuntu1.spec.0.template.0.metadata.0.labels.app
        }
        port {
            port = 9100
        }
    }
}

resource "kubernetes_deployment" "ubuntu2" {
    metadata {
        name = "ubuntu2"
        namespace = kubernetes_namespace.wickstack.metadata.0.name
    }
    spec {
        replicas = 1
        selector {
            match_labels = {
                app = "ubuntu1"
            }
        }
        template {
            metadata {
                labels = {
                    app = "ubuntu1"
                }
            }
            spec {
                container {
                    image = "ubuntu:noble-20240225"
                    name = "ubuntu1"
                    port {
                        container_port = 9200
                    }
                    command = [
                    "/bin/sh",
                    "-c",
                    "apt-get update && apt-get install -y wget && wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-arm64.tar.gz && tar xvfz node_exporter-1.2.2.linux-arm64.tar.gz && ./node_exporter-1.2.2.linux-arm64/node_exporter --web.listen-address=:9200 & sleep infinity"
                    ]
                
                  liveness_probe {
                    exec {
                      command = ["bash", "-c", "ps aux"]
                    }
                    initial_delay_seconds = 30
                    period_seconds        = 10
                  }

                  readiness_probe {
                    exec {
                      command = ["bash", "-c", "ps aux"]
                    }
                    initial_delay_seconds = 5
                    period_seconds        = 10
                  }
                }
            }
        }
    }
}



resource "kubernetes_service" "ubuntu2_exporter" {
    metadata {
        name = "ubuntu2exporter"
        namespace = kubernetes_namespace.wickstack.metadata.0.name
    }
    spec {
        selector = {
            app = kubernetes_deployment.ubuntu2.spec.0.template.0.metadata.0.labels.app
        }
        port {
            port = 9200
        }
    }
}