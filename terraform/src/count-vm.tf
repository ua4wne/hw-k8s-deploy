data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}

resource "yandex_compute_instance" "k8s" {
  count       = 5
  name        = "node-${count.index + 1}"
  hostname    = "node-${count.index + 1}"
  platform_id = var.vm_web_platform
  zone        = var.default_zone
  resources {
    cores         = var.resources_vm["cores"]
    memory        = var.resources_vm["memory"]
    core_fraction = var.resources_vm["core_fraction"]
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.resources_vm["disk_size"]
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vm_web_nat
  }


  metadata = {
    serial-port-enable = var.metadata_map.metadata.serial-port-enable
    ssh-keys           = "${var.vm_web_user}:${var.metadata_map.metadata.ssh-keys}"
  }

}
