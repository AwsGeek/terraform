# Configure the AWS Provider
provider "aws" {
    region = "${var.region}"
}

module "vpc" {
  source       = "./vpc"
  tags         = "${var.tags}"
  region       = "${var.region}"
  vpc_cidr     = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
}


