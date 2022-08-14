terraform {
  backend "gcs" {
    bucket = "sapin-terraform-state"
    prefix = "terraform/state"
  }
}
