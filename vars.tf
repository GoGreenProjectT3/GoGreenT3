
variable "subnet_cidrs_private_1a" {
  description = "CIDR for Private Subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  type        = list(any)
}

variable "subnet_cidrs_private_1c" {
  description = "CIDR for Private Subnets"
  default     = [ "10.0.5.0/24", "10.0.6.0/24"]
  type        = list(any)
}
