# KVM Guest VM 

## Prerequisites

- A KVM enabled host.
- The Terraform CLI, version 1.0.8 or later.
- Hashicorp tls provider vesion >= 3.1.0.
- dmacvicar/libvirt provider version >= 0.6.12.
- The git CLI.

## Setup

Add the KVM guest VM details in to `maint.tf` file.

```shell
vi ./terraform/guest-vm-centos/maint.tf

module "centos-2" {
 source = "./modules/tf-module-kvm-guest-centos"

 guest_vm  = {
   "name"          = "centos-2"
   "dnsDomain"     = "kvm.local"
   "memoryMB"      = "4096"
   "vcpu"          = "4"
   "diskPool"      = "images"
   "network"       = "default"
   "imageSource"   = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
 }
}
```

Use the following commands to create the KVM guest VMs.

```shell

terraform init
terraform plan
terrafrm apply
```

## Variables

The following are the variables used for this module.

| Name | Type | Map Keys | Default | Description |
|:-:|:-:|:-:|:-:| :-: |
|guest_vm | Map | name | instance-1 | Name of the guest VM. |
| | | dnsDomain | kvm.local | FQDN for the guest VM. |
| | | memoryMB | 2048 | Memory allocation for the guest VM in MB. |
| | | vcpu | 2 | vCPU allocation for the guest vm. |
| | | diskPool | vmpool | The KVM storage pool. If doesn't exists, needs to created before running this module. |
| | | network | default | The KVM network VLAN for the guest VM. |
| | | imageSource | < CentOS cloud image URL > | The CentOS cloud image URL. |

## Outputs

This module will provide the following outputs.

| Output Name | Type | Description |
|:-:|:-:|:-:|
| ip  | string  | IP address of the KVM guest VM. |

## Troubleshooting

### To check KVM guest VM

```shell
# virsh list --all
```

### To check KVM guest IP

```shell
# virsh net-dhcp-leases default
```

## Create NAT port forwarding to KVM guest VM

### Setup qemu hooks

Create qemu file.

```shell
mkdir -p /etc/libvirt/hooks/qemu
chmod +x /etc/libvirt/hooks/qemu
```

Copy the shell script into newly created qemu file.

```shell
cp ./kvm-scripts/qemu-hooks.sh /etc/libvirt/hooks/qemu
```

### Allow access from outside to the KVM guest

```shell
# vi /etc/libvirt/hooks/qemu
```

Add the follwoing line to the end of the file.

```shell
addForward <KVM gues VM name>  <KVM host network interface> <KVM host IP address> <Listening port on KVM host>  virbr0 <KVM guest VM IP> <KM guest VM service port> <protocol>

```

### Run the following commands to check iptables rules fo rthe guest VM

```shell
# iptables-save -t nat
# iptables-save -t filter | grep FORWARD
# iptables -t nat -L -n -v
# iptables -L FORWARD -nv --line-number
```
