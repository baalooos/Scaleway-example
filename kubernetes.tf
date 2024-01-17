resource "scaleway_k8s_cluster" "k8s_cluster" {
  name                        = var.env_name
  version                     = "1.24.3"
  cni                         = "cilium"
  private_network_id          = scaleway_vpc_private_network.pn.id
  delete_additional_resources = false

  autoscaler_config {
    disable_scale_down               = false
    scale_down_unneeded_time         = "2m"
    scale_down_delay_after_add       = "30m"
    scale_down_utilization_threshold = 0.5
    estimator                        = "binpacking"
    expander                         = "random"
    ignore_daemonsets_utilization    = true
  }
}

resource "scaleway_k8s_pool" "k8s_pool_0" {
  cluster_id        = scaleway_k8s_cluster.k8s_cluster.id
  name              = "${var.env_name}-kube-pool-0"
  node_type         = var.cluster_pool_0_node_type
  size              = 1
  min_size          = var.cluster_pool_0_min_size
  max_size          = var.cluster_pool_0_max_size
  autoscaling       = true
  autohealing       = true
  container_runtime = "containerd"
}

resource "scaleway_k8s_pool" "k8s_pool_1" {
  count             = var.deploy_backup_pool ? 1 : 0
  zone              = var.backup_pool_zone
  cluster_id        = scaleway_k8s_cluster.k8s_cluster.id
  name              = "${var.env_name}-kube-pool-1"
  node_type         = var.cluster_pool_1_node_type
  size              = 1
  min_size          = var.cluster_pool_1_min_size
  max_size          = var.cluster_pool_1_max_size
  autoscaling       = true
  autohealing       = true
  container_runtime = "containerd"
}
