variable "key_pair_name" {
  description = "The name of the key pair"
}

variable "rsa_bits" {
  description = "The number of bits for RSA key generation"
  default     = 4096
}
