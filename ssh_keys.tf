## Create TLS Private key
resource "tls_private_key" "rsa-4096-lab" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## Print OPENSSH key
output "private_key_value" {
  value     = tls_private_key.rsa-4096-lab.private_key_openssh
  sensitive = true
}