resource "kubernetes_service" "stock-reader" {
  metadata {
    name = "stock-reader"
  }
  spec {
    selector = {
      App = kubernetes_deployment.stock_reader.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"

  }
}
