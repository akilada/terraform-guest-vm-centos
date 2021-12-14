# Terraform Module to create KVM guest VM (Centos)

This terraform module create a CentOS based guest VM in a KVM host.

Note: This Terraform module needs to be run on the KVM host.

## Prerequisites

- The Terraform CLI, version 1.0.8 or later.
- A host with KVM installed.
- The git CLI.

## Setup

The following example shows how to use the module.

```hcl

module "vpc" {
  source = "./modules/tf-module-kvm-guest-centos"
}

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
