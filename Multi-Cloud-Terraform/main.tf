resource "null_resource" "health_check" {
  depends_on = [aws_instance.qr_scanner, google_compute_instance.qr_scanner]

  provisioner "local-exec" {
    command = <<EOT
      echo "=== MULTI-CLOUD DEPLOYMENT VALIDATION ==="
      echo "AWS Instance: http://${aws_eip.qr_scanner.public_ip}"
      echo "GCP Instance: http://${google_compute_instance.qr_scanner.network_interface[0].access_config[0].nat_ip}"
      
      echo "Testing AWS instance..."
      curl -s -f http://${aws_eip.qr_scanner.public_ip} > /dev/null && echo "✅ AWS instance healthy" || echo "❌ AWS instance failed"
      
      echo "Testing GCP instance..."
      curl -s -f http://${google_compute_instance.qr_scanner.network_interface[0].access_config[0].nat_ip} > /dev/null && echo "✅ GCP instance healthy" || echo "❌ GCP instance failed"
      
      echo "Deployment completed at: $(date)"
    EOT
  }
}