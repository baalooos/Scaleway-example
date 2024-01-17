// Create a random password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
}

// Create a secret
resource "scaleway_secret" "db_secret" {
  name        = "${var.env_name}-db_secret"
  description = "this is the secret for the db"
  tags        = [var.env_name, "terraform"]
}

// Create a version with the password in it
resource "scaleway_secret_version" "v1" {
  description = "version1"
  secret_id   = scaleway_secret.db_secret.id
  data        = random_password.db_password.result
}

// Create the DB
resource "scaleway_rdb_instance" "db_instance" {
  name                      = "${var.env_name}-rdb"
  node_type                 = var.db_node_type
  engine                    = "PostgreSQL-15"
  is_ha_cluster             = var.db_is_ha
  disable_backup            = var.db_disable_backup
  backup_schedule_frequency = var.db_backup_frequency
  backup_schedule_retention = var.db_backup_retention
  disable_public_endpoint   = var.db_disable_public_endpoint

  user_name = var.db_admin_name
  password  = scaleway_secret_version.v1.data
  private_network {
    pn_id = scaleway_vpc_private_network.pn.id
  }
}

// Create the read replica
resource "scaleway_rdb_read_replica" "replica" {
  count = var.db_enable_read_replica ? 1 : 0

  instance_id = scaleway_rdb_instance.db_instance.id
  private_network {
    private_network_id = scaleway_vpc_private_network.pn.id
  }
  same_zone = false
}
