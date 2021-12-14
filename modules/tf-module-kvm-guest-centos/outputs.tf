# output "guest_vm_password" {
#   value     = random_password.password.result 
#   sensitive = true
# }

output "ip" {
  value = "${libvirt_domain.domain-centos.network_interface.0.addresses.0}"
}