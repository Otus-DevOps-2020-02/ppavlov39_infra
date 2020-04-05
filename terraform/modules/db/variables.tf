variable zone {
  description = "Zone"
  default     = "europe-west4-b"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable db_disk_image {
  description = "Disk image for reddit db"
  default = "reddit-db-base"
}
variable app_name {
  description = "App name"
  default = "reddit-app"
}
variable machine_type {
  description = "Machine type"
  default = "f1-micro"
}
variable source_ranges {
  description = "Allowed source IP addresses"
  default = ["0.0.0.0/0"]
}


