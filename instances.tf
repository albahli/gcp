resource "google_compute_instance" "private_instance" {
  project      = var.project_id
  name         = "instance-1"
  zone         = "us-central1-a"
  machine_type = "e2-medium"
  tags         = ["private-linux-instance"]

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-9"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.private_subnet.id
  }

}