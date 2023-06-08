terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.84.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "sf-devops"
    region     = "ru-central1-a"
    key        = "terraform/terraform.tfstate"
    access_key = "XXXXXX"
    secret_key = "XXXXXX"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}


provider "yandex" {
  token     = "${var.auth_token}"
  cloud_id  = "${var.cloud_id}"
  folder_id = "${var.folder_id}"
  zone      = "${var.zone}"
}


resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.128.0.0/24"]
}



resource "yandex_compute_image" "debian11" {
   source_family = "debian-11"
}

resource "yandex_compute_disk" "vm1-sda" {
  name       = "sda"
  type       = "network-ssd"
  zone       = "ru-central1-a"
  size       = 10
  block_size = 4096
}


resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"
  allow_stopping_for_update = true


  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.debian11.id
      size = 16
    }
  }


  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}

resource "yandex_compute_instance" "vm-2" {
  name = "terraform2"
  allow_stopping_for_update = true


  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.debian11.id
      size = 16
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}


resource "yandex_compute_instance" "vm-3" {
  name = "terraform3"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.debian11.id
      size = 16
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}




output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

output "internal_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.ip_address
}


output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.nat_ip_address
}

