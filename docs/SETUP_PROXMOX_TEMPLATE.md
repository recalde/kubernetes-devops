# Setting Up Proxmox VM Template and Installing Ansible Galaxy Collections

This guide provides step-by-step instructions to:

1. **Create a Cloud-Init VM Template in Proxmox VE.**
2. **Install the required Ansible Galaxy collections.**

## **Prerequisites**

- **Proxmox VE** server access with sufficient permissions.
- **Ansible** installed on your control machine.
- **Internet access** from both the Proxmox server and the control machine.

---

## **1. Create a Cloud-Init VM Template in Proxmox**

### **Step 1.1: Download Debian Cloud Image**

Log into your Proxmox server via SSH.

```bash
cd /var/lib/vz/template/iso
wget https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2
```

### **Step 1.2: Create a New VM in Proxmox**

In the Proxmox web interface:

1. Click **Create VM**.
2. **General Tab**:
   - **VM ID**: `9000` (or any unused ID).
   - **Name**: `debian-cloudinit-template`.
3. **OS Tab**:
   - **Use CD/DVD disc image file (iso)**: Select **Do not use any media**.
4. **System Tab**:
   - Leave defaults or adjust as needed.
5. **Hard Disk Tab**:
   - **Bus/Device**: `SCSI`.
   - **Storage**: `local-lvm`.
   - **Disk size**: `8 GB`.
6. **CPU Tab**:
   - **Cores**: `2`.
7. **Memory Tab**:
   - **Memory**: `2048 MB`.
8. **Network Tab**:
   - **Bridge**: `vmbr0`.
9. **Confirm Tab**:
   - Review settings and click **Finish**.

### **Step 1.3: Import the Cloud Image**

Back in the SSH session:

```bash
qm importdisk 9000 debian-11-genericcloud-amd64.qcow2 local-lvm
```

### **Step 1.4: Attach the Imported Disk to the VM**

```bash
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
```

### **Step 1.5: Configure Cloud-Init**

```bash
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --serial0 socket --vga serial0
```

### **Step 1.6: Convert the VM into a Template**

```bash
qm template 9000
```

### **Step 1.7: Verify the Template**

- In the Proxmox web interface, ensure the VM `debian-cloudinit-template` is listed under **Templates**.

---

## **2. Install Required Ansible Galaxy Collections**

On your control machine (where Ansible is installed):

### **Step 2.1: Install Ansible**

If Ansible is not installed, install it using:

- **On Debian/Ubuntu:**

  ```bash
  sudo apt update
  sudo apt install ansible
  ```

- **On macOS using Homebrew:**

  ```bash
  brew install ansible
  ```

### **Step 2.2: Install the Proxmox Collection**

Install the `community.general` collection, which includes Proxmox modules:

```bash
ansible-galaxy collection install community.general
```

### **Step 2.3: Verify Installation**

Ensure the collection is installed:

```bash
ansible-galaxy collection list
```

Look for `community.general` in the list.

---

## **Next Steps**

Proceed to the next guide to execute the Ansible playbooks:

- **[Execute Ansible Playbooks to Create VMs and Setup Kubernetes](EXECUTE_PLAYBOOKS.md)**

---

## **Troubleshooting**

- **Proxmox API Access**: Ensure that the user you're using for API access has the necessary permissions.
- **Network Configuration**: Confirm that your network allows the control machine to communicate with the Proxmox server and that VMs can communicate over the network.

---

**Author**: https://github.com/recalde/

**Date**: 2024-10-17