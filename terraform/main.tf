terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

# Создание сети
resource "yandex_vpc_network" "monitoring-network" {
  name = "monitoring-network"
}

# Создание подсети
resource "yandex_vpc_subnet" "monitoring-subnet" {
  name           = "monitoring-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.monitoring-network.id
  v4_cidr_blocks = ["10.1.0.0/16"]
}

# Группа безопасности
resource "yandex_vpc_security_group" "monitoring-sg" {
  name        = "monitoring-sg"
  network_id  = yandex_vpc_network.monitoring-network.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ClickHouse HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8123
  }

  ingress {
    protocol       = "TCP"
    description    = "ClickHouse native"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 9000
  }

  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ВМ для ClickHouse
resource "yandex_compute_instance" "clickhouse-vm" {
  name        = "clickhouse-vm"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 22.04
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.monitoring-subnet.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.monitoring-sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: ubuntu
          groups: sudo
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh-authorized-keys:
            - ${file(var.ssh_public_key_path)}
      EOF
  }
}

# ВМ для Vector
resource "yandex_compute_instance" "vector-vm" {
  name        = "vector-vm"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 22.04
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.monitoring-subnet.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.monitoring-sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: ubuntu
          groups: sudo
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh-authorized-keys:
            - ${file(var.ssh_public_key_path)}
      EOF
  }
}

# ВМ для Lighthouse
resource "yandex_compute_instance" "lighthouse-vm" {
  name        = "lighthouse-vm"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 22.04
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.monitoring-subnet.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.monitoring-sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
    user-data = <<-EOF
      #cloud-config
      users:
        - name: ubuntu
          groups: sudo
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh-authorized-keys:
            - ${file(var.ssh_public_key_path)}
      EOF
  }
}
