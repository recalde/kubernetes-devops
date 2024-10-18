
# Create top-level files
touch ansible.cfg
touch inventory.ini
touch create_vms.yml
touch kubernetes_setup.yml
touch cloud_init_userdata.yml
touch .gitignore

# Create the roles directory structure
mkdir -p roles/ephemeral_os/tasks
mkdir -p roles/ephemeral_os/handlers

# Create empty main.yml files in the roles
touch roles/ephemeral_os/tasks/main.yml
touch roles/ephemeral_os/handlers/main.yml

# Provide feedback
echo "Directory structure and empty files have been created successfully in '$BASE_DIR'."