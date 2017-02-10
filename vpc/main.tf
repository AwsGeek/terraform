variable "tags" { type = "map" }
variable "region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidrs" { type = "list" }
variable "private_subnet_cidrs" { type = "list" }
variable "availability_zones" { type = "list" }

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
  tags  = "${merge(var.tags, map("Name", "${var.tags["Product"]} VPC"))}"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags  = "${merge(var.tags, map("Name", "${var.tags["Product"]} Internet Gateway"))}"
}

module "az1" {
  source       = "./az"
  region       = "${var.region}"
  vpc          = "${aws_vpc.vpc.id}"
  tags         = "${var.tags}"
  igw          = "${aws_internet_gateway.default.id}"
  public_subnet_cidr  = "${element(var.public_subnet_cidrs,0)}"
  private_subnet_cidr = "${element(var.private_subnet_cidrs,0)}"
  availability_zone   = "${element(var.availability_zones,0)}"
}

module "az2" {
  source       = "./az"
  region       = "${var.region}"
  vpc          = "${aws_vpc.vpc.id}"
  tags         = "${var.tags}"
  igw          = "${aws_internet_gateway.default.id}"
  public_subnet_cidr  = "${element(var.public_subnet_cidrs,1)}"
  private_subnet_cidr = "${element(var.private_subnet_cidrs,1)}"
  availability_zone   = "${element(var.availability_zones,1)}"
}

output "az1_private_subnet" {
  value = "${module.az1.private_subnet}"
}

output "az2_private_subnet" {
  value = "${module.az2.private_subnet}"
}

