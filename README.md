# Kubernetes Cluster Automation with Ansible and Proxmox

This project automates the creation of a Kubernetes cluster using Ansible and Proxmox VE. It provisions virtual machines (VMs) on Proxmox, configures them as ephemeral as possible using cloud-init, and sets up a Kubernetes cluster with one master node and two worker nodes.

## **Project Purpose**

- **Automation**: Utilize Ansible to automate the entire process of VM creation and Kubernetes cluster setup.
- **Learning**: Provide a hands-on approach to learning about infrastructure automation, Kubernetes deployment, and managing ephemeral systems.
- **Efficiency**: Leverage Proxmox's capabilities and Ansible's automation to deploy a cluster efficiently.

## **Project Structure**

```
your-git-repo/
├── ansible.cfg
├── inventory.ini
├── create_vms.yml
├── kubernetes_setup.yml
├── cloud_init_userdata.yml
├── roles/
│   └── ephemeral_os/
│       ├── tasks/
│       │   └── main.yml
│       └── handlers/
│           └── main.yml
├── .gitignore
└── README.md
```

- **ansible.cfg**: Ansible configuration file setting defaults.
- **inventory.ini**: Inventory file defining Proxmox and Kubernetes hosts.
- **create_vms.yml**: Playbook to create VMs in Proxmox using cloud-init.
- **kubernetes_setup.yml**: Playbook to install Kubernetes and set up the cluster.
- **cloud_init_userdata.yml**: Cloud-init configuration for initial VM setup.
- **roles/ephemeral_os**: Ansible role to configure the VMs for an ephemeral OS.
- **.gitignore**: Specifies files for Git to ignore.
- **README.md**: Project documentation (this file).

## **Getting Started**

To get started with this project, follow these steps:

1. **Prerequisites**:
   - Proxmox VE server with API access.
   - Control machine with Ansible installed.
   - Network configuration allowing VMs to communicate.
   - Basic knowledge of Ansible and Proxmox.

2. **Setup Instructions**:

   - **[Setup Proxmox VM Template and Ansible Galaxy Collections](docs/SETUP_PROXMOX_TEMPLATE.md)**
   - **[Execute Ansible Playbooks to Create VMs and Setup Kubernetes](docs/EXECUTE_PLAYBOOKS.md)**

## **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## **Contributing**

Contributions are welcome! Please open an issue or submit a pull request for any improvements or additions.

## **Support**

If you have any questions or need assistance, feel free to open an issue or contact the project maintainers.

---

**Author**: https://github.com/recalde/

**Date**: 2024-10-17