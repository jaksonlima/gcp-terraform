terraform {
  required_version = ">= 1.14.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.25.0"
    }
  }

  backend "gcs" {
    bucket = "cluster-terraform-state-020420262154"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
