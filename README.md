# microstack-terraform-ansible-01
Single Node Microstack on Ubuntu - provisioned with Terraform - config with Ansible

See the file: **`instructions.txt`**

## TODO

1. Clean these files up to not use 'terraform' everywhere
2. Try specifying 'machine_type' in different way to state CPU, RAM, disk size.

    Its currently:

    ```text
    Flavor Name | m1.medium
    Flavor ID | 3
    RAM | 4GB
    VCPUs | 2 VCPU
    Disk | 20GB
    ```

    **`=> make changes and if they work, verify in GUI`**

3. Have the terraform files output info for use in a dynamic inventory thing for Ansible to use
4. Move the nginx setup into Ansible
    (and remove the sudo lines from provisioner, but replace with something else to keep as an example)

5. Add comments for all terraform & ansible code

6. Double check instructions and improve / fix as needed.

7. Open up any WEB links in terraform code (and elsewhere) and extract any useful info into comments (just incase web links disappear).

### AOB ?