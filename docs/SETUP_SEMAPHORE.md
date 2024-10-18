# Using Kubernetes Cluster Automation Project with Ansible Semaphore UI

This guide explains how to use the Kubernetes cluster automation project with **Ansible Semaphore UI**, a web-based user interface for Ansible. By integrating with Semaphore, you can manage and execute your Ansible playbooks through a user-friendly web interface, schedule tasks, and monitor execution.

## **Table of Contents**

- [Prerequisites](#prerequisites)
- [Overview](#overview)
- [Installation of Ansible Semaphore](#installation-of-ansible-semaphore)
- [Configuring Semaphore for the Project](#configuring-semaphore-for-the-project)
  - [Step 1: Create a Project](#step-1-create-a-project)
  - [Step 2: Add Inventory](#step-2-add-inventory)
  - [Step 3: Add Environment Variables](#step-3-add-environment-variables)
  - [Step 4: Add Repository](#step-4-add-repository)
  - [Step 5: Create Templates](#step-5-create-templates)
- [Executing Playbooks via Semaphore UI](#executing-playbooks-via-semaphore-ui)
- [Scheduling Tasks](#scheduling-tasks)
- [Monitoring and Logs](#monitoring-and-logs)
- [Additional Considerations](#additional-considerations)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)
- [Author](#author)

---

## **Prerequisites**

- **Ansible Semaphore** installed and running.
- Access to the **control machine** where Ansible is installed.
- The **Kubernetes cluster automation project** cloned from your Git repository.
- **SSH access** to the Proxmox server and the VMs.
- **Ansible Vault password** (if using encrypted variables).

## **Overview**

Ansible Semaphore provides a web interface to manage and execute Ansible playbooks. By integrating your project with Semaphore, you can:

- Execute playbooks with a click of a button.
- Schedule playbook execution.
- Manage inventories and environment variables.
- Monitor execution logs and status.

## **Installation of Ansible Semaphore**

If you haven't installed Ansible Semaphore yet, follow these steps:

### **Install Ansible Semaphore**

Refer to the [official documentation](https://docs.ansible-semaphore.com/installation/) for detailed instructions.

- **Using Docker**:

  ```bash
  docker run -d \
    --name=ansible-semaphore \
    -p 3000:3000 \
    -v /path/to/config:/etc/semaphore \
    -v /path/to/data:/data \
    ansiblesemaphore/semaphore
  ```

- **Using Binary**:

  Download the latest release from [GitHub Releases](https://github.com/ansible-semaphore/semaphore/releases) and follow the installation guide.

### **Initial Configuration**

After installation, open the web interface (e.g., `http://your-server-ip:3000`) and complete the initial setup:

- **Create an admin user**.
- **Configure database settings** (SQLite, MySQL, or PostgreSQL).

## **Configuring Semaphore for the Project**

### **Step 1: Create a Project**

1. Log in to the Semaphore UI.
2. Click on **"Create New Project"**.
3. **Project Name**: Enter a name (e.g., `Kubernetes Cluster Automation`).
4. **Summary**: (Optional) Provide a brief description.
5. Click **"Create"**.

### **Step 2: Add Inventory**

Ansible Semaphore uses inventories to define hosts and groups.

1. In your project, navigate to the **"Inventory"** tab.
2. Click **"Create Inventory"**.
3. **Name**: Enter `Project Inventory`.
4. **Type**: Select **"Static"**.
5. **Inventory Content**: Paste the content of your `inventory.ini` file.
6. Click **"Create"**.

### **Step 3: Add Environment Variables**

If your playbooks use environment variables or you need to define Ansible configurations, add them here.

1. Go to the **"Environment Variables"** tab.
2. Click **"Create Environment"**.
3. **Name**: Enter `Project Environment`.
4. **Variables**: Add any environment variables, e.g.:

   ```ini
   ANSIBLE_CONFIG=ansible.cfg
   ```

5. Click **"Create"**.

### **Step 4: Add Repository**

Add your Git repository containing the playbooks.

1. Navigate to the **"Repositories"** tab.
2. Click **"Create Repository"**.
3. **Name**: Enter `Automation Repo`.
4. **Git URL**: Enter the URL to your Git repository (e.g., `https://github.com/yourusername/your-git-repo.git`).
5. **Authentication**: If the repository is private, provide credentials:
   - **SSH Key**: Paste your private SSH key.
   - **Username/Password**: Enter credentials if using HTTPS.
6. **Branch**: Specify the branch to use (e.g., `main`).
7. Click **"Create"**.

### **Step 5: Create Templates**

Templates define how playbooks are executed.

#### **Template 1: Create VMs**

1. Go to the **"Templates"** tab.
2. Click **"Create Template"**.
3. **Name**: Enter `Create VMs`.
4. **Playbook**: Enter the path to `create_vms.yml` (e.g., `create_vms.yml`).
5. **Repository**: Select `Automation Repo`.
6. **Inventory**: Select `Project Inventory`.
7. **Environment**: Select `Project Environment`.
8. **Arguments**: Add any necessary Ansible arguments (e.g., `--ask-vault-pass` if using Ansible Vault).
9. **Extra Variables**: (Optional) Define extra variables.
10. Click **"Create"**.

#### **Template 2: Set Up Kubernetes**

1. Click **"Create Template"** again.
2. **Name**: Enter `Setup Kubernetes Cluster`.
3. **Playbook**: Enter the path to `kubernetes_setup.yml`.
4. **Repository**: Select `Automation Repo`.
5. **Inventory**: Select `Project Inventory`.
6. **Environment**: Select `Project Environment`.
7. **Arguments**: Add necessary arguments.
8. Click **"Create"**.

## **Executing Playbooks via Semaphore UI**

### **Execute "Create VMs" Template**

1. In the **"Templates"** tab, find `Create VMs`.
2. Click **"Execute"**.
3. **Task Variables**: If needed, override variables for this execution.
4. **Advance Options**: Set options like **"Dry Run"** or **"Debug"**.
5. Click **"Execute"**.
6. Monitor the task execution in the **"Tasks"** tab.

### **Execute "Setup Kubernetes Cluster" Template**

1. After the VMs are created, execute the `Setup Kubernetes Cluster` template following the same steps.

## **Scheduling Tasks**

You can schedule templates to run at specific times.

1. Go to the **"Schedules"** tab.
2. Click **"Create Schedule"**.
3. **Name**: Enter a name for the schedule.
4. **Template**: Select the template to execute.
5. **Cron Expression**: Define when the task should run (e.g., `0 0 * * *` for daily at midnight).
6. Click **"Create"**.

## **Monitoring and Logs**

- **Tasks Tab**: View the status of executed tasks.
- Click on a task to see detailed logs.
- **Output**: Check the standard output and error for troubleshooting.

## **Additional Considerations**

### **SSH Keys**

- Ensure that Semaphore has access to the necessary SSH keys to connect to your Proxmox server and VMs.
- You can add SSH keys in the **"Keys"** section of your project.

### **Ansible Vault**

- If using Ansible Vault, Semaphore needs to know the Vault password.
- When executing a template, you can provide the Vault password in the **"Extra Variables"** or configure it in the environment.

### **Customizing Execution**

- Use **Extra Variables** to override variables at runtime.
- Adjust **Ansible Arguments** for verbosity (`-v`, `-vvv`) or other options.

## **Troubleshooting**

- **Repository Issues**: If Semaphore cannot clone your repository, check the Git URL and authentication settings.
- **SSH Connection Failures**: Ensure that the control machine (where Semaphore runs) can SSH into the target hosts.
- **Playbook Errors**: Check the logs in the **"Tasks"** tab for detailed error messages.
- **Permissions**: Ensure Semaphore has the necessary permissions to read/write files and execute Ansible.

## **Resources**

- **Ansible Semaphore Documentation**: [https://docs.ansible-semaphore.com/](https://docs.ansible-semaphore.com/)
- **Ansible Documentation**: [https://docs.ansible.com/](https://docs.ansible.com/)

---

**Author**: https://github.com/recalde/

**Date**: 2024-10-17