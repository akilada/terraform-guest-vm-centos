module "centos-2" {
  source = "./modules/tf-module-kvm-guest-centos"

  guest_vm  = {
    "name"          = "centos-2"
    "dnsDomain"     = "kvm.local"
    "memoryMB"      = "2048"
    "vcpu"          = "2"
    "diskPool"      = "vmpool"
    "network"       = "default"
    "imageSource"   = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
  }
}