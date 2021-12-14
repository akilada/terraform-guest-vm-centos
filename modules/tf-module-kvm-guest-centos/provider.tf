terraform {
  required_version = ">= 1.0.2"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.6.12"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"
    }
  }
}

# Instance of the provider
provider "libvirt" {
  uri = "qemu:///system"
}

# provider "tls" {}