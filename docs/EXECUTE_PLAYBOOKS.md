# Executing Ansible Playbooks to Create VMs and Set Up Kubernetes

This guide provides instructions to:

1. **Configure Ansible variables and inventory.**
2. **Run the Ansible playbook to create VMs in Proxmox.**
3. **Run the Ansible playbook to set up the Kubernetes cluster.**

## **Prerequisites**

- **Proxmox VE** with the Cloud-Init template created.
- **Ansible** installed with the required collections.
- **SSH access** to the VMs (Ansible will use SSH to configure the VMs).

---

## **1. Configure Ansible Variables and Inventory**

### **Step 1.1: Update `inventory.ini`**

Edit `inventory.ini` to reflect your environment:

```ini
[proxmox]
proxmox_host ansible_host=YOUR_PROXMOX_IP

[proxmox:vars]
ansible_user=YOUR_PROXMOX_USERNAME
ansible_password=YOUR_PROXMOX_PASSWORD
ansible_connection=local

[kubernetes-master]
kube-master ansible_host=192.168.1.100 ansible_user=debian

[kubernetes-workers]
kube-worker1 ansible_host=192.168.1.101 ansible_user=debian
kube-worker2 ansible_host=192.168.1.102 ansible_user=debian

[kubernetes:children]
kubernetes-master
kubernetes-workers
```

**Replace:**

- `YOUR_PROXMOX_IP` with your Proxmox server's IP.
- `YOUR_PROXMOX_USERNAME` and `YOUR_PROXMOX_PASSWORD` with Proxmox credentials.
- Update `ansible_host` IPs under `[kubernetes-master]` and `[kubernetes-workers]` to match your network.
- Ensure the `ansible_user` is set to the username you configured in cloud-init (e.g., `debian`).

### **Step 1.2: Update Variables in `create_vms.yml`**

Edit `create_vms.yml` and adjust variables:

```yaml
vars:
  node: "proxmox_node_name"  # Replace with your Proxmox node name
  template_id: 9000          # ID of your Cloud-Init template
  pool: "your_pool"          # Replace with your Proxmox pool name if applicable
  ci_password: "your_vm_password"  # Replace with a secure password
  gw: "YOUR_GATEWAY_IP"            # Replace with your network gateway IP
```

**Replace:**

- `proxmox_node_name` with your Proxmox node's name.
- `your_pool` with your Proxmox pool name, or remove if not using pools.
- `your_vm_password` with a secure password for the VMs.
- `YOUR_GATEWAY_IP` with your network's gateway IP address.

### **Step 1.3: Secure Sensitive Information**

Consider using Ansible Vault to encrypt sensitive variables like passwords.

Encrypt a variable:

```bash
ansible-vault encrypt_string 'your_vm_password' --name 'ci_password'
```

Replace the `ci_password` variable in `create_vms.yml` with the encrypted value.

---

## **2. Run the Ansible Playbook to Create VMs**

### **Step 2.1: Run `create_vms.yml`**

Execute the playbook:

```bash
ansible-playbook create_vms.yml
```

If you used Ansible Vault, add `--ask-vault-pass`:

```bash
ansible-playbook create_vms.yml --ask-vault-pass
```

### **Step 2.2: Verify VM Creation**

- Log into the Proxmox web interface.
- Ensure that the VMs `kube-master`, `kube-worker1`, and `kube-worker2` are created and running.
- Check that the VMs have the correct IP addresses.

---

## **3. Run the Ansible Playbook to Set Up Kubernetes**

### **Step 3.1: Verify SSH Connectivity**

Ensure that you can SSH into the VMs from your control machine:

```bash
ssh debian@192.168.1.100
```

If SSH keys are not set up, you might need to enter the password you set in cloud-init.

### **Step 3.2: Update `kubernetes_setup.yml` if Necessary**

Ensure that the Kubernetes version and network settings are appropriate.

### **Step 3.3: Run `kubernetes_setup.yml`**

Execute the playbook:

```bash
ansible-playbook kubernetes_setup.yml
```

If you used Ansible Vault:

```bash
ansible-playbook kubernetes_setup.yml --ask-vault-pass
```

### **Step 3.4: Monitor the Playbook Execution**

- The playbook will install Kubernetes dependencies on all nodes.
- It will initialize the master node and set up the network plugin.
- Worker nodes will join the cluster using the join command.

---

## **4. Verify Kubernetes Cluster Setup**

### **Step 4.1: Check Node Status**

SSH into the master node:

```bash
ssh debian@192.168.1.100
```

Check the status of the nodes:

```bash
kubectl get nodes
```

Expected output:

```
NAME            STATUS   ROLES           AGE     VERSION
kube-master     Ready    control-plane   Xs      v1.26.0
kube-worker1    Ready    <none>          Xs      v1.26.0
kube-worker2    Ready    <none>          Xs      v1.26.0
```

### **Step 4.2: Deploy a Test Application**

Deploy a simple nginx deployment to test the cluster:

```bash
kubectl create deployment nginx --image=nginx
kubectl get pods
```

---

## **5. Clean Up (Optional)**

If you wish to remove the VMs and start over:

- In Proxmox, delete the VMs manually, or create an Ansible playbook to delete them using the `community.general.proxmox_kvm` module.

---

## **Troubleshooting**

- **SSH Connectivity Issues**: Ensure that the control machine can SSH into the VMs. You may need to add SSH keys or adjust firewall settings.
- **Ansible Errors**: Read the error messages carefully. Missing variables or incorrect paths are common issues.
- **Kubernetes Join Failures**: Ensure that the worker nodes can reach the master node over the network.

---

## **Additional Considerations**

- **Ephemeral OS Configuration**: The `ephemeral_os` role modifies the OS to be as stateless as possible. Test this configuration thoroughly.
- **Security**: Always secure your credentials and sensitive information. Use Ansible Vault where appropriate.

---

## **Next Steps**

- **Explore Kubernetes Features**: Deploy applications, set up services, and experiment with Kubernetes resources.
- **Integrate CI/CD**: Connect your cluster with GitLab or other CI/CD tools.
- **Monitor and Manage**: Install tools like Prometheus and Grafana for monitoring.

---

**Author**: https://github.com/recalde/

**Date**: 2024-10-17