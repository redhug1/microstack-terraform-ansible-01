resource "openstack_compute_keypair_v2" "terraform" {
  name       = "terraform"
  public_key = file("${var.ssh_key_file}.pub")
}

resource "openstack_networking_network_v2" "terraform" {
  name           = "terraform"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "terraform" {
  name            = "terraform"
  network_id      = openstack_networking_network_v2.terraform.id
  cidr            = "10.0.0.0/24"
  ip_version      = 4
  dns_nameservers = [
    "194.168.4.100",
    "194.168.8.100",
    "8.8.8.8",
    "8.8.4.4"
  ]
}

resource "openstack_networking_router_v2" "terraform" {
  name                = "terraform"
  admin_state_up      = "true"
  external_network_id = data.openstack_networking_network_v2.terraform.id
}

resource "openstack_networking_router_interface_v2" "terraform" {
  router_id = openstack_networking_router_v2.terraform.id
  subnet_id = openstack_networking_subnet_v2.terraform.id
}

# might need: Creates a routing entry on a OpenStack V2 router.
# see: https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_router_route_v2

# as of 4.Apr.2021 the microstack setup does not allow me to access the floating IP
# created on the compute node from the controller node when this code is run on the
# compute node.
#
# The bridge / vlan in microstack is not configured to allow the above, but may be
# in the near future.
#
# BUT this code does run on the controller node OK
#     then on windows machine, in Ubuntu WSL2 terminal, do:
#  sudo ssh -N -L 8002:10.20.20.192:80 rhys@192.168.124.223
#     to crate a tunnel and then in firefox on A8 open localhost:8002
#     to see 'Welcome to nginx'

resource "openstack_networking_secgroup_v2" "terraform" {
  name        = "terraform"
  description = "Security group for the Terraform example instances"
}

resource "openstack_networking_secgroup_rule_v2" "terraform_22" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform.id
}

resource "openstack_networking_secgroup_rule_v2" "terraform_80" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform.id
}

resource "openstack_networking_secgroup_rule_v2" "terraform" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.terraform.id
}

resource "openstack_networking_floatingip_v2" "terraform" {
  pool = var.pool
}

resource "openstack_compute_instance_v2" "terraform" {
  name            = "terraform"
  image_name      = var.image
  flavor_name     = var.machine_type
  key_pair        = openstack_compute_keypair_v2.terraform.name
  security_groups = [openstack_networking_secgroup_v2.terraform.name]
  user_data       =<<EOF
#cloud-config
password: ubuntu
chpasswd: { expire: False }
ssh_pwauth: True
final_message: \"Thunderbirds are go\n\"
EOF

  network {
    uuid = openstack_networking_network_v2.terraform.id
  }
}

resource "openstack_compute_floatingip_associate_v2" "terraform" {
  floating_ip = openstack_networking_floatingip_v2.terraform.address
  instance_id = openstack_compute_instance_v2.terraform.id
}

resource "null_resource" "provision" {
  depends_on = [openstack_compute_floatingip_associate_v2.terraform]

  connection {
    host        = openstack_networking_floatingip_v2.terraform.address
    user        = var.ssh_user_name
    private_key = file(var.ssh_key_file)
  }

/*
Don't know why, but need to run update and upgrade a 2nd time for the nginx install to work
*/
  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update",
      "sudo apt -y upgrade",
      "sudo apt -y update",
      "sudo apt -y upgrade",
      "sudo apt install -y nginx",
      "sudo service nginx start",
    ]
  }
}
