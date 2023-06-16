resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu" {

   family = var.vm_web_image
}

# VM Monitoring

resource "yandex_compute_instance" "platform-monitoring" {
  name        = "${local.monitoring}" 
  platform_id = "standard-v1"

  resources {
    cores         = var.vm_monitoring_resources.cores
    memory        = var.vm_monitoring_resources.memory
    core_fraction = var.vm_monitoring_resources.core_fraction
}

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = "network-hdd"
      size = var.vm_monitoring_disk.size
    }
  }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.vms_ssh_root_key.serial-port-enable
    ssh-keys           = var.vms_ssh_root_key.ssh-keys
  }
}

# VM Node1

resource "yandex_compute_instance" "platform-node1" {

  name        = "${local.node1}"
  platform_id = "standard-v1"
  resources {
    cores         = var.vm_node1_resources.cores
    memory        = var.vm_node1_resources.memory
    core_fraction = var.vm_node1_resources.core_fraction
}

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = "network-hdd"
      size = var.vm_node1_disk.size
    }
  }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.vms_ssh_root_key.serial-port-enable
    ssh-keys           = var.vms_ssh_root_key.ssh-keys
  }
}

# VM Node2

resource "yandex_compute_instance" "platform-node2" {

  name        = "${local.vm_node2}"
  platform_id = "standard-v1"
  resources {
    cores         = var.vm_node2_resources.cores
    memory        = var.vm_node2_resources.memory
    core_fraction = var.vm_node2_resources.core_fraction
}

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = "network-hdd"
      size = var.vm_node2_disk.size
    }
  }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.vms_ssh_root_key.serial-port-enable
    ssh-keys           = var.vms_ssh_root_key.ssh-keys
  }
}