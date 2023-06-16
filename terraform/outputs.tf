
output "vm_external_ip_address_monitoring" {
value = yandex_compute_instance.platform-monitoring.network_interface.0.ip_address
description = "vm external ip"
}

output "vm_external_ip_address_node1" {
value = yandex_compute_instance.platform-node1.network_interface.0.ip_address
description = "vm external ip"
}

output "vm_external_ip_address_node2" {
value = yandex_compute_instance.platform-node2.network_interface.0.ip_address
description = "vm external ip"
}