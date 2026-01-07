output "clickhouse_public_ip" {
  value = yandex_compute_instance.clickhouse-vm.network_interface.0.nat_ip_address
  description = "Public IP address of ClickHouse VM"
}

output "clickhouse_private_ip" {
  value = yandex_compute_instance.clickhouse-vm.network_interface.0.ip_address
  description = "Private IP address of ClickHouse VM"
}

output "vector_public_ip" {
  value = yandex_compute_instance.vector-vm.network_interface.0.nat_ip_address
  description = "Public IP address of Vector VM"
}

output "vector_private_ip" {
  value = yandex_compute_instance.vector-vm.network_interface.0.ip_address
  description = "Private IP address of Vector VM"
}

output "lighthouse_public_ip" {
  value = yandex_compute_instance.lighthouse-vm.network_interface.0.nat_ip_address
  description = "Public IP address of Lighthouse VM"
}

output "lighthouse_private_ip" {
  value = yandex_compute_instance.lighthouse-vm.network_interface.0.ip_address
  description = "Private IP address of Lighthouse VM"
}

output "inventory_content" {
  value = <<-EOT
    # Auto-generated inventory from Terraform
    # Run: terraform output -raw inventory_content > ../ansible/inventory/prod.yml
    
    all:
      hosts:
        clickhouse-01:
          ansible_host: ${yandex_compute_instance.clickhouse-vm.network_interface.0.nat_ip_address}
          ansible_user: ubuntu
          private_ip: ${yandex_compute_instance.clickhouse-vm.network_interface.0.ip_address}
        vector-01:
          ansible_host: ${yandex_compute_instance.vector-vm.network_interface.0.nat_ip_address}
          ansible_user: ubuntu
          private_ip: ${yandex_compute_instance.vector-vm.network_interface.0.ip_address}
        lighthouse-01:
          ansible_host: ${yandex_compute_instance.lighthouse-vm.network_interface.0.nat_ip_address}
          ansible_user: ubuntu
          private_ip: ${yandex_compute_instance.lighthouse-vm.network_interface.0.ip_address}
      children:
        clickhouse:
          hosts:
            clickhouse-01:
        vector:
          hosts:
            vector-01:
        lighthouse:
          hosts:
            lighthouse-01:
  EOT
  description = "Ansible inventory content"
}
