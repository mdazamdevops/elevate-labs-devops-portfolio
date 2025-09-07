# Compute Instance with corrected Ubuntu image
resource "google_compute_instance" "qr_scanner" {
  name         = "qr-scanner-instance-${formatdate("YYYYMMDD", timestamp())}"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240110"  # Specific Ubuntu 20.04 image
      # OR use the family name:
      # image_family = "ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }

  metadata_startup_script = file("${path.module}/scripts/deploy-qr-scanner.sh")
  tags = ["http-server", "https-server"]
}