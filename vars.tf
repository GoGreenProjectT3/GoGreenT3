
# variable "subnet_cidrs_private_1a" {
#   description = "CIDR for Private Subnets"
#   default     = ["10.0.3.0/24", "10.0.4.0/24"]
#   type        = list(any)
# }

<<<<<<< HEAD
# variable "subnet_cidrs_private_1c" {
#   description = "CIDR for Private Subnets"
#   default     = [ "10.0.5.0/24", "10.0.6.0/24"]
#   type        = list(any)
# }
=======
variable "subnet_cidrs_private_1c" {
  description = "CIDR for Private Subnets"
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
  type        = list(any)
}
variable "ssh-location" {
  default     = "0.0.0.0/0"
  description = "SSH variable for bastion host"
  type        = string
}

variable "key_name" {
  default = "LL-TEST"
  type    = string
}



>>>>>>> 8dd1ab5862f8bf5be677a0a5f09c4cd221890aaf
