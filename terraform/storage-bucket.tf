provider "google" {
  version = "~> 2.15"
  project = var.project
  region = var.region
}

module "storage-bucket" {
  source = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name = ["stor-bucket-infra-ppk", "stor-bucket-onfra-ppk2"]
}

output storage-bucket_url {
  value = module.storage-bucket.url
}



