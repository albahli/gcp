terraform {
  backend "gcs" {
    bucket = "19bbc9f3142b563f-terraform-remote-backend"
    credentials = "${var.credentials}"
  }
}

resource "google_storage_bucket" "terraform_state" {
  name     = "19bbc9f3142b563f-terraform-remote-backend"
  location = "US"

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

