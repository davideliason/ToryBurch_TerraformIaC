
variable "cidr_block" {
  description = "The default CIDR block for the VPC"
  type        = string
  default     = "10.17.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to the VPC"
  type        = map(string)
  default     = {}
}


variable "availability_zone-1" {
  description = "The availability zone for the public subnet"
  type        = string
  default     = "us-west-2a"
}

variable "availability_zone-2" {
  description = "The availability zone for the public subnet"
  type        = string
  default     = "us-west-2b"
}

variable "map_public_ip_on_launch" {
  description = "A boolean flag to enable/disable public IP assignment for the subnet"
  type        = bool
  default     = true
}


