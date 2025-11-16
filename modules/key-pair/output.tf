output "key_pair_name" {
  description = "The name of the generated key pair"
  value       = aws_key_pair.tf-key-pair.key_name
}

output "private_key_path" {
  description = "The path to the private key file"
  value       = local_file.tf-key.filename
}
