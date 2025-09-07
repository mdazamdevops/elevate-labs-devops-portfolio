output "aws_instance_ip" {
  description = "Public IP address of the AWS EC2 instance"
  value       = aws_eip.qr_scanner.public_ip
}

output "gcp_instance_ip" {
  description = "Public IP address of the GCP compute instance"
  value       = google_compute_instance.qr_scanner.network_interface[0].access_config[0].nat_ip
}

output "aws_instance_details" {
  description = "Details of the AWS instance"
  value = {
    public_ip   = aws_eip.qr_scanner.public_ip
    instance_id = aws_instance.qr_scanner.id
    instance_type = aws_instance.qr_scanner.instance_type
  }
}

output "gcp_instance_details" {
  description = "Details of the GCP instance"
  value = {
    public_ip   = google_compute_instance.qr_scanner.network_interface[0].access_config[0].nat_ip
    instance_id = google_compute_instance.qr_scanner.id
    machine_type = google_compute_instance.qr_scanner.machine_type
  }
}

output "deployment_status" {
  description = "Deployment status message"
  value       = "Multi-cloud deployment completed successfully. Use the above IP addresses to access your QR scanner application."
}