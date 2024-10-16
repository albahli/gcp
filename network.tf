resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  project       = var.project_id
  name          = "private-subnet"
  ip_cidr_range = "10.10.20.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "k8s_subnet" {
  project       = var.project_id
  name          = "k8s-subnet"
  ip_cidr_range = "10.10.30.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}


resource "google_compute_router_nat" "nat" {
  project                            = var.project_id
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"                     # NAT IPs allocation handeld by GCP
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES" # Allow all ranges in every subnets.

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "router-1"
  region  = google_compute_subnetwork.private_subnet.region
  network = google_compute_network.vpc_network.id
}