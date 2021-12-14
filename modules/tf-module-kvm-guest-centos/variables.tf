variable "virsh_network_name" {
  description   = "The network name for the KVM guest VM."
  default       = "default" 
}

variable "guest_vm" {
  description = "This is required KVM guest VM configs"
  type        = map
  default     = {
    "name"          = "instance-1"
    "dnsDomain"     = "kvm.local"
    "memoryMB"      = "2048"
    "vcpu"          = "2"
    "diskPool"      = "vmpool"
    "network"       = "default"
    "imageSource"   = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  }
}
