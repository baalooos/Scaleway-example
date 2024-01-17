resource "scaleway_vpc" "vpc" {
  name = var.env_name
  tags = [var.env_name, "terraform"]
}

resource "scaleway_vpc_private_network" "pn" {
  vpc_id = scaleway_vpc.vpc.id
  name   = "${var.env_name}-private"
  tags   = [var.env_name, "terraform"]

  ipv4_subnet {
    subnet = var.network_private_cidr
  }
}

// Reserve an IP for the Public Gateway
resource "scaleway_vpc_public_gateway_ip" "gw_ip" {
}

// Create the Public Gateway
resource "scaleway_vpc_public_gateway" "pgw" {
  name            = "${var.env_name}-gateway"
  type            = var.network_pgw_type
  bastion_enabled = var.network_pgw_enable_bastion
  ip_id           = scaleway_vpc_public_gateway_ip.gw_ip.id
}

// Attach Public Gateway, Private Network and DHCP config together
resource "scaleway_vpc_gateway_network" "vpc" {
  gateway_id         = scaleway_vpc_public_gateway.pgw.id
  private_network_id = scaleway_vpc_private_network.pn.id
  cleanup_dhcp       = true
  enable_masquerade  = true
  ipam_config {
    push_default_route = true
  }
}
