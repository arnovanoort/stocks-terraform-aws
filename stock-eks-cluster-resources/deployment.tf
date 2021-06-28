variable "db_hostname" {}

resource "kubernetes_deployment" "stock_reader" {
  metadata {
    name = "stock-reader-deployment"
    labels = {
      App = "stock-reader"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "stock-reader"
      }
    }
    template {
      metadata {
        labels = {
          App = "stock-reader"
        }
      }
      spec {
        container {
          image = "temmink/stock-reader:latest"
          name  = "stock-reader"

          port {
            container_port = 8080
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
          env {
            name  = "db.url"
            value = "r2dbc:postgresql://${var.db_hostname}"
          }
          env {
            name  = "spring.flyway.url"
            value = "jdbc:postgresql://${var.db_hostname}/stocks"
          }
        }
      }
    }
  }
}
