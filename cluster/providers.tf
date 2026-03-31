terraform {
  required_version = ">= 1.14.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.25.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

