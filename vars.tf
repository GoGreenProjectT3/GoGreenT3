
variable "ssh-location" {
  default     = "0.0.0.0/0"
  description = "SSH variable for bastion host"
  type        = string
}

variable "key_name" {
  default = "LL-TEST"
  type    = string
}



