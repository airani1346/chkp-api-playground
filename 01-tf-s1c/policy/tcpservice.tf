resource "checkpoint_management_service_tcp" "healthcheck" {
      port = "8117"
      name = "${random_id.id.hex}-AzureHealthCheck"
      color = "blue"
      match_for_any = false 
              }

resource "checkpoint_management_service_tcp" "tcp8090" {
      port = "8090"
      name = "${random_id.id.hex}-TCP-8090"
      color = "blue"
      match_for_any = false
            }

resource "checkpoint_management_service_tcp" "tcp33890" {
      port = "33890"
      name = "${random_id.id.hex}-TCP-33890"
      color = "blue"
      match_for_any = false
            }
