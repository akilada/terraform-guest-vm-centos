# TechniPal AWS Demo Reference Architecture

## Prerequisites

- A KVM enabled host.
- The Terraform CLI, version 1.0.8 or later.
- Hashicorp tls provider vesion >= 3.1.0.
- dmacvicar/libvirt provider version >= 0.6.12.
- The git CLI.

## Setup

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
