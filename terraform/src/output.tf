output "all_servers" {
  description = "nodes params"
  value = concat([for vm in yandex_compute_instance.k8s :
    zipmap(["name", "ip", "fqdn"], [vm.name, vm.network_interface[0].nat_ip_address, vm.fqdn])])
}
