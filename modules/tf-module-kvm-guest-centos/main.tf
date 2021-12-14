# Generate a random password for guest VM
resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "_%@"
}

# Generate SSH key pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Export public key to a file
resource "local_file" "public_key" {
  content         = tls_private_key.ssh.public_key_openssh
  filename        = "${var.guest_vm["name"]}_public_key.pub"
  file_permission = "0600"
}

# Export private key to a file
resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${var.guest_vm["name"]}_private_key.pem"
  file_permission = "0600"
}

# Define VM volume
resource "libvirt_volume" "os_image" {
  name      = "${var.guest_vm["name"]}.qcow2"
  pool      = var.guest_vm["diskPool"]
  source    = var.guest_vm["imageSource"]
  format    = "qcow2"
}

# Get user data info
data "template_file" "user_data" {
  template = "${file("${path.module}/cloud_init.cfg")}"

  vars = {
    hostname = var.guest_vm["name"]
    fqdn     = "${var.guest_vm["name"]}.${var.guest_vm["dnsDomain"]}"
    password = random_password.password.result
    pubKey   = tls_private_key.ssh.public_key_openssh
  }
}

# Use CloudInit to add the instance
resource "libvirt_cloudinit_disk" "centosinit" {
  name      = "${var.guest_vm["name"]}-cloudinit.iso"
  pool      = var.guest_vm["diskPool"]
  user_data = "${data.template_file.user_data.rendered}"
}

# Create the guest VM
resource "libvirt_domain" "domain-centos" {
  name   = "${var.guest_vm["name"]}"
  memory = "${var.guest_vm["memoryMB"]}"
  vcpu   = "${var.guest_vm["vcpu"]}"

  disk { 
    volume_id = libvirt_volume.os_image.id
  }

  network_interface {
    network_name = "${var.guest_vm["network"]}"
  }

  cloudinit = libvirt_cloudinit_disk.centosinit.id

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = "true"
  }
}