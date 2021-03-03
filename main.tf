terraform {
  required_providers {
    kubernetes = {
     source = "hashicorp/kubernetes"
    }
  }
}
provider "kubernetes" {
  # config map => keys
  config_path = "~/.kube/config"
}
resource "deploy_to_kubernetes" "flaskapp" {
  metadata {
    annotations = {
      name = "python_flask_app"
    }
    labels = {
      mylabel = "python_flask_app"
    }
    name = "python_flask_app"
  }
}

resource "kubernetes_deployment" "python_flask_app" {
  metadata {
    name = "python_flask_app"
    labels = {
      App = "python_flask_app"
    }
  }
  spec {
    # deployes 4 replica
    replicas = 4
    selector {
      match_labels = {
        App = "python_flask_app"
      }
    }
    template {
      metadata {
        labels = {
          App = "python_flask_app"
        }
      }
      spec {
        container {
          image = "211896/gmn_docker_image"
          name  = "python_flask_app"

          port {
            container_port = 5000
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "512Mi"
            }
            requests = {
              cpu    = "500m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
  # deployment timeout
 timeouts {
    create = "1m"
    update = "1m"
    delete = "2m"
  }
}
resource "kubernetes_service" "python_flask_app" {
  metadata {
    name = "python_flask_app"
  }
  spec {
    selector = {
      App = kubernetes_deployment.python_flask_app.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 9090
      target_port = 9090
    }
    type = "NodePort"
  }
}
