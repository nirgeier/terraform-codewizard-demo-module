
# Namespace
resource "kubernetes_namespace" "namespaces" {
  metadata {
    name = var.namespace
  }
}

# Deployment
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = {
      App = var.name
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = var.name
      }
    }
    template {
      metadata {
        labels = {
          App = var.name
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

#  Service
resource "kubernetes_service" "nginx-svc" {
  metadata {
    name      = "nginx-example"
    namespace = var.namespace
  }
  spec {
    selector = {
      App = var.name
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
