resource "google_container_cluster" "k8s_cluster" {
  project             = var.project_id
  name                = "gke-cluster"
  location            = "us-central1-a"
  network             = google_compute_network.vpc_network.id
  subnetwork          = google_compute_subnetwork.k8s_subnet.id
  deletion_protection = false
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "10.11.30.0/28"
  }
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  project    = var.project_id
  name       = "node-pool-v1"
  location   = "us-central1-a"
  cluster    = google_container_cluster.k8s_cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    tags         = ["gke-worker-node"]

  }

}
