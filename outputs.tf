output "tpot_external_ip" {
  description = "The external IP address of the T-Pot honeypot VM"
  value       = google_compute_instance.tpot_honeypot_vm.network_interface[0].access_config[0].nat_ip
}
