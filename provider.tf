# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name   = var.openstack_user_name
  tenant_name = var.openstack_tenant_name
#  password    = var.openstack_password
# password is filled in from env variable: OS_PASSWORD
  auth_url    = var.openstack_auth_url
#  region      = var.openstack_region_name
}

# for more info on provider, see:
# https://github.com/terraform-provider-openstack/terraform-provider-openstack/blob/main/website/docs/index.html.markdown
