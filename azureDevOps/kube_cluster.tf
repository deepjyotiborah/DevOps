resource "azurerm_resource_group" "test" {
  name     = "acctestRG1"
  location = "East US"
}
resource "azurerm_kubernetes_cluster" "test" {
  name                = "acctestaks1"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  dns_prefix          = "acctestagent1"
  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }
  linux_profile {
    admin_username = "adminuser"
    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAj/forJI+fR7P/E2BNVcUY2yMfNdz9wAjn6GaHDrlaolqaCy+It1Hej2iYVKa5dOFpofRX8vccvDnsQh4IL+SrboRMdMNevtpSSSNUaIlYzTC0342Pm0jZV5Gjjee0dY+QSbOw1o4I4ARGukuZBDWny9ixWzIDhGHsQ6mqcChjfhnbBVatRg02t8ky2dTMPZpUAMyyNZPhyloq6BpPq3ybzqPOmrF0bPIU5xRBXoDb6bZpnZIZO9koRYYRoRwmVGOejqa0uiJNaiwBbbkL/yof6qD+cz6ir4VGTKS0kTDSLON2Ao8CZcUG8U2uW9y81crJHCaHPVoQiWsbaGdxmVX deepjyotiborah@LE0005.local"
    }
  }
  service_principal {
    client_id     = "${azuread_service_principal.example1.application_id}"
    client_secret = "${azuread_application_password.example1.value}"
  }
  tags = {
    Environment = "Production"
  }
}
resource "azuread_application" "example1" {
  name                       = "example1"
  homepage                   = "https://homepage"
  identifier_uris            = ["http://uris"]
  reply_urls                 = ["http://replyurls"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}
resource "azuread_service_principal" "example1" {
  application_id                = "${azuread_application.example1.application_id}"
  app_role_assignment_required  = false
  tags = ["example", "tags", "here"]
}
data "azurerm_subscription" "primary" {}
resource "azurerm_role_assignment" "aks" {
  scope                = "${data.azurerm_subscription.primary.id}"
  role_definition_name = "Owner"
  principal_id       = "${azuread_service_principal.example1.id}"
}
resource "random_password" "password" {
  length = 16
  special = false
  override_special = "_%@"
}
resource "azuread_application_password" "example1" {
  application_id = "${azuread_application.example1.id}"
  value          = "${random_password.password.result}"
  end_date       = "2020-01-01T01:02:03Z"
}
output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.test.kube_config.0.client_certificate}"
}
output "kube_config" {
  value = "${azurerm_kubernetes_cluster.test.kube_config_raw}"
}
output "client_secret" {
  description = "Client Secret"
  value       = "${azuread_application_password.example1.value}"
}
output "client_id" {
  description = "Client ID"
  value       = "${azuread_service_principal.example1.application_id}"
}