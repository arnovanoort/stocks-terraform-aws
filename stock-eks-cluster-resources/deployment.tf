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
            value = "r2dbc:postgresql://${var.stock-reader-db-hostname}"
          }
          env {
            name  = "spring.flyway.url"
            value = "jdbc:postgresql://${var.stock-reader-db-hostname}/stocks"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "stock_trading_algorithms" {
  metadata {
    name = "stock-trading-algorithms"
    labels = {
      App = "stock-trading-algorithms"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "stock-trading-algorithms"
      }
    }
    template {
      metadata {
        labels = {
          App = "stock-trading-algorithms"
        }
      }
      spec {
        container {
          image = "temmink/stock-trading-algorithms:latest"
          name  = "stock-trading-algorithms"

          port {
            container_port = 8081
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
            name  = "spring.datasource.url"
            value = "jdbc:postgresql://${var.stock-trading-algorithms-db-hostname}/tradingalgorithms"
          }
          env {
            name  = "stockdata.url.host"
            value = "http://stock-reader"
          }
        }
      }
    }
  }
}
