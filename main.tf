provider "google" {
  project = "blockshield-honeypot"
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "tpot_honeypot_vm" {
  name         = "tpot-honeypot-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = var.disk_size_gb
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["http-server", "https-server"]

  metadata_startup_script = file("install_tpot.sh")
}

resource "google_compute_firewall" "default" {
  name    = "tpot-allow-http-https-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "64297"] # 64297 is T-Pot's default web UI port
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}

resource "google_compute_firewall" "tpot-ssh" {
  name    = "tpot-allow-ssh-64295"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["64295"]
  }
  source_ranges = ["0.0.0.0/0"]  # For open access; restrict for security
  target_tags   = ["http-server", "https-server"]  # Match your VM's tags
  priority      = 1000
  description   = "Allow SSH to T-Pot on port 64295"
}
