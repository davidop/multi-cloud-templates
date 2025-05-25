variable "bucket_name" {}

resource "google_storage_bucket" "this" {
  name     = var.bucket_name
  location = "EU"
}

output "bucket_id" {
  value = google_storage_bucket.this.id
}
