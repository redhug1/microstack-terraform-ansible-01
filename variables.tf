variable "image" {
  default = "Ubuntu-20.04"
}

# image creation:
# https://docs.openstack.org/image-guide/create-images-automatically.html
# https://docs.openstack.org/image-guide/
# https://docs.openstack.org/horizon/latest/admin/manage-images.html
# https://docs.openstack.org/image-guide/ubuntu-image.html

# https://cloud-images.ubuntu.com/daily/server/focal/current/

# look at above manifest file for clue to user and password

# https://www.server-world.info/en/note?os=Ubuntu_20.04&p=openstack_ussuri&f=6

# https://computingforgeeks.com/adding-images-openstack-glance/

# https://bobcares.com/blog/add-glance-cloud-images-to-openstack/

# https://portal.nutanix.com/page/documents/kbs/details?targetId=kA00e000000CshJCAS

variable "machine_type" {
  default = "m1.medium"
}

variable "openstack_user_name" {
  description = "The username for the Tenant."
  default     = "admin"
}

# 'tenant' is the old term for a Project.
# Horizon dashboard uses 'Project'
# A project is a set of resources.
# Users are associated to projects with roles, and projects are resource owners.
# A resource is any of: compute, network, storage, etc.
# Any single user may have access to more than one tenant/project, but once
# signed into a project, they can only see and access the resources available
# in that project.
variable "openstack_tenant_name" {
  description = "The name of the Tenant."
#  default     = "my_tenant"
  default     = "admin"
}

variable "openstack_password" {
  description = "The password for the Tenant."
  default     = "ubuntu"
}

variable "openstack_auth_url" {
  description = "The endpoint url to connect to OpenStack."
  default     = "http://192.168.124.101:5000/v3/"
}

variable "ssh_key_file" {
  default = "~/.ssh/MY_KEY"
}

variable "ssh_user_name" {
  default = "ubuntu"
}

variable "pool" {
  # the name "external" below is the Name in Networks in Network Section of openstack GUI
  default = "external"
  # see following for better way of spec'ing network:
  # https://github.com/hashicorp/terraform/issues/14538
}

variable "openstack_region_name" {
  default = "microstack"
}

# https://github.com/OpenTelekomCloud/terraform-otc/issues/20

# https://stackoverflow.com/questions/52389887/terraform-auth-not-working-when-adding-resources

# https://github.com/terraform-provider-openstack/terraform-provider-openstack/blob/main/examples/attach-format-mount-volume/openrc.sample
