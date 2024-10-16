resource "google_project_service" "project" {
  for_each = toset(local.gcp_services)
  project  = var.project_id
  service  = each.key
}


locals {
  gcp_services = [
    "container.googleapis.com",
  ]
}
