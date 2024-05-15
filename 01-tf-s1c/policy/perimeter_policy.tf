resource "checkpoint_management_package" "AWS_Perimeter" {
  name = "${random_id.id.hex}-AWS_Perimeter"
  color = "orange"
  threat_prevention = true
  access = true
  #
  # For autoscaling we can't be sure what target will be used as the list can grow and shrink over time
  #
  lifecycle {
    ignore_changes = [installation_targets]
  }
}

resource "checkpoint_management_access_layer" "AWS_Perimeter_URLF" {
  name = "${random_id.id.hex}-${checkpoint_management_package.AWS_Perimeter.name} URLF"
  applications_and_url_filtering = true
  firewall =true
  color = "blue"
  shared = true
}

resource "checkpoint_management_access_rule" "blockrule1" {
                name = "${random_id.id.hex}-Block Categories"
                enabled = true
                action = "Drop"
                source = [ "Any" ]
                destination = [ "Any" ]
                service = [ checkpoint_management_application_site.blocksite1.name ]
                layer = checkpoint_management_access_layer.AWS_Perimeter_URLF.name
                track = {
                  accounting = false
	                alert = "none"
                  enable_firewall_session = true
                  per_connection = true
                  per_session = true
                  type = "Log"
                  }
                position = {top = "top"}
                lifecycle {
                   ignore_changes = [action]
                   }
                }
resource "checkpoint_management_access_rule" "allowrule2" {
                name = "${random_id.id.hex}-Allowed Categories"
                enabled = true
                action = "Accept"
                action_settings = {
                  enable_identity_captive_portal = false
                  }
                source = [ "Any" ]
                destination = ["All_Internet"]
                service = [ "Low Risk", "Very Low Risk", "Medium Risk" ]
                layer = checkpoint_management_access_layer.AWS_Perimeter_URLF.name
                track = {
                  accounting = false
	                alert = "none"
                  enable_firewall_session = true
                  per_connection = true
                  per_session = true
                  type = "Log"
                  }
                position = {below = checkpoint_management_access_rule.blockrule1.name}
                lifecycle {
                   ignore_changes = [action]
                   }
                }
resource "checkpoint_management_access_rule" "allowrule3" {
                name = "${random_id.id.hex}-Allow All"
                enabled = true
                action = "Accept"
                action_settings = {
                  enable_identity_captive_portal = false
                  }
                source = [ "Any" ]
                destination = ["All_Internet"]
                service = [ "Any" ]
                layer = checkpoint_management_access_layer.AWS_Perimeter_URLF.name
                track = {
                  accounting = false
	                alert = "none"
                  enable_firewall_session = true
                  per_connection = true
                  per_session = true
                  type = "Log"
                  }
                position = {below = checkpoint_management_access_rule.allowrule2.name}
                lifecycle {
                   ignore_changes = [action]
                   }
                }
