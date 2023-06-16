 variable "token" {
  type        = string
  description = ""
}

variable "cloud_id" {
  type        = string
  description = ""
}

variable "folder_id" {
  type        = string
  description = ""
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "e9bfl31n6cfsdq6stini"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###ssh map vers
variable "vms_ssh_root_key" {
  type = map(any)
  default = {
   serial-port-enable   = 1
   ssh-keys             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCED/bj9qwN7AB3O7KUmgH2EadKCFpsQwAive7qtSYMEX4TeGILoCbDftmOI0vcNKy0SmJSVEL7t+hip6YwA67vDrvhkmsdUuGH0LbYoF0BX+VFBEbrS2z2wLrS+kzYACxt8BzADPZ+IFXGWXOmwk2aLQzteDMq9R83k+P2lgzQve5qNQzxbehDA5ouTtFsrR+v99AuFv15XQFsA1SjSUupSqfx2XbRZXp8t/JLDyBvqlxZitibrJvMrnIOfTLyFLNQOJNO8Sxb9kLtBgfFymauCdeOG9ngfbWV8rayaJPjIAEdW6qxATpq56qHcg3FNjWT9yRvaUFK5nTpNUvvGG2qb+GVM7u3zMHitHmFJqkKyhdIthXewLAOv6pp2tCVOLPg3oPYMt+ex2of0lMqVzJMXCV0Nx9pi5nJRlY3r5BzN9bdVBtQ4IUXmhLWQ4TtDtIarTy3wqELyQVYTTEhzBYfqlehEsT+i/533K6BiBV6OvPvAU+tfklj48C94zy7a0= root@kali"
  }
}
###yandex_compute_image vars
variable "vm_web_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu release name"
}
###name VM vars
variable "vm_monitoring" {
  type        = string
  default     = "monitoring"
  description = "VM1 name"
}

variable "vm_node1" {
  type        = string
  default     = "node1"
  description = "VM2 name"
}

variable "vm_node2" {
  type        = string
  default     = "node2"
  description = "VM3 name"
}

###vm_web_resources var

variable "vm_monitoring_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 100
 }
}

variable "vm_node1_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 100
  }
}

variable "vm_node2_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 2
    core_fraction  = 100
  }
}

variable "vm_monitoring_disk" {
  type = map(number)
  default = {
    size          = 20
  }
}

variable "vm_node1_disk" {
  type = map(number)
  default = {
    size          = 20
  }
}

variable "vm_node2_disk" {
  type = map(number)
  default = {
    size          = 20
  }
}

