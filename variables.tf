// Variables for test environment
// Common variables

variable "env_name" {
  default = "test"
}
// CIDR to use, at least /22 for Kapsule
variable "network_private_cidr" {
  default = "192.168.0.0/22"
}
// Type of the Public Gateway
variable "network_pgw_type" {
  default = "VPC-GW-S"
}
// SSH bastion on Public Gateway
variable "network_pgw_enable_bastion" {
  default = true
}

variable "db_node_type" {
  default = "DB-DEV-S"
}
// Username for db, Password is auto generated
variable "db_admin_name" {
  default = "admin"
}
// Do we need HA or not
variable "db_is_ha" {
  default = true
}
// Do we need read replica or not
variable "db_enable_read_replica" {
  default = true
}
// Do we need backup or not
variable "db_disable_backup" {
  default = false
}
// Frequency in hours
variable "db_backup_frequency" {
  default = 24
}
// Retention in days
variable "db_backup_retention" {
  default = 7
}
// Do we need a public endpoint
variable "db_disable_public_endpoint" {
  default = true
}

// Config for the first pool
// Instance type
variable "cluster_pool_0_node_type" {
  default = "PLAY2-NANO"
}
// Min number of instances
variable "cluster_pool_0_min_size" {
  default = 1
}
// Max number of instances
variable "cluster_pool_0_max_size" {
  default = 10
}

// Config for the second pool
// Do we need a second pool
variable "deploy_backup_pool" {
  default = true
}
// Deploy the pool in another zone for better availability
variable "backup_pool_zone" {
  default = "fr-par-2"
}
// Instance type
variable "cluster_pool_1_node_type" {
  default = "PLAY2-MICRO"
}
// Min number of instances
variable "cluster_pool_1_min_size" {
  default = 1
}
// Max number of instances
variable "cluster_pool_1_max_size" {
  default = 10
}

// Do we need cert manager
variable "deploy_cert_manager" {
  default = true
}
// Version for cert manager
variable "cert_manager_version" {
  default = "v1.13.3"
}
