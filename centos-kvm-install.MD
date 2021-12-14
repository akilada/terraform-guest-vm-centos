# How To

The purpose of the document is to create a How-To document for installing KVM on Fedora 30+.

## Steps

### Step 1: Ensure your CPU has Intel VT or AMD-V Virtualization extensions

```shell
cat /proc/cpuinfo | egrep "vmx|svm"
```

### Step 2: Install KVM / QEMU on Fedora 30+

```shell
dnf -y install bridge-utils libvirt virt-install qemu-kvm
```

Verify that kernel modules are loaded:

```shell
lsmod | grep kvm
```

Also, install the following tools for VM management:

```shell
dnf -y install libvirt-devel virt-top libguestfs-tools
```

### Step 3: Start and enable KVM daemon

```shell
systemctl start libvirtd
systemctl enable libvirtd
```
