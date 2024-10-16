
# Allow SSH access to private VMs without Public IP
resource "google_compute_firewall" "firewall_rule" {
  project = var.project_id
  name    = "allow-ingress-from-iap"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]        # This range contains all IP addresses that IAP uses for TCP forwarding
  target_tags   = ["private-linux-instance"] # Private linux machines
}

# Allow access from private subnet to GKE
resource "google_compute_firewall" "internal_firewall_rule" {
  project = var.project_id
  name    = "allow-ingress-from-vm"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  direction     = "INGRESS"
  source_ranges = [google_compute_subnetwork.private_subnet.ip_cidr_range] # Private subnet CIDR
  target_tags   = ["gke-worker-node"]                                      # GKE workers
}

