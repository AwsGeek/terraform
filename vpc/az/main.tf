variable "region" {}
variable "vpc" {}
variable "igw" {}
variable "tags" { type = "map" }
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "availability_zone" {}

/* Public subnet */
resource "aws_subnet" "public" {
  vpc_id            = "${var.vpc}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "${var.availability_zone}"
  tags  = "${merge(var.tags, map("Name", "${var.tags["Product"]} Public Subnet"))}"
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.igw}"
  }
  tags  = "${merge(var.tags, map("Name", "${var.tags["Product"]} Public Route Table"))}"
}

resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public.id}"
}

resource "aws_subnet" "private" {
  vpc_id            = "${var.vpc}"
  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "${var.availability_zone}"
  map_public_ip_on_launch = false
  depends_on = ["aws_nat_gateway.gw"]
  tags  = "${merge(var.tags, map("Name", "${var.tags["Product"]} Private Subnet"))}"
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw.id}"
  }
  tags  = "${merge(var.tags, map("Name", "${var.tags["Product"]} Private Route Table"))}"
}

resource "aws_vpc_endpoint" "private-s3" {
    vpc_id = "${var.vpc}"
    service_name = "com.amazonaws.${var.region}.s3"
    route_table_ids = ["${aws_route_table.private.id}"]
}

resource "aws_route_table_association" "private" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}

output "public_subnet" {
  value = "${aws_subnet.public.id}"
}

output "private_subnet" {
  value = "${aws_subnet.private.id}"
}
