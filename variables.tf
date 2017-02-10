variable "vpc_name"     { 
  description = "The name of the VPC"
  default     = "Terraformed VPC"
}

variable "tags" {
  description = "A map of tags to apply to created resources"
  default = { 
    Product = "Terraformed" 
    Environment = "Production" 
    Developer = "@awsgeek" 
  }
}

variable "region"     { 
  description = "AWS region to host your network"
  default     = "us-west-2" 
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "172.17.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR for public subnet"
  default     = [ "172.17.0.0/22", "172.17.4.0/22" ]
}

variable "private_subnet_cidrs" {
  description = "CIDR for private subnet"
  default     = [ "172.17.32.0/21", "172.17.40.0/21" ]
}

variable "availability_zones" {
  description = "Availability zones"
  default     = [ "us-west-2a", "us-west-2b" ]
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default     = "awsgeek"
}
