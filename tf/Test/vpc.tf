#Define VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
      Name = "test-vpc"
  }
}

#Define Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "ap-southeast-2a"

  tags {
      Name = "Web Public Subnet"
  }
}

#Define Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "ap-southeast-2b"

  tags {
      Name = "Database Private Subnet"
  }
}

#Define Internet Gateway
resource "aws_internet_gateway" "int_gw" {
    vpc_id = "${aws_vpc.default.id}" 

    tags {
        Name = "VPC IGW"
    } 
}

#Define Route Table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.int_gw.id}"
  }

  tags {
      Name = "Public Subnet RT"
  }
}

#Assign the Route table to the public subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

#Security group for Public Subnet
resource "aws_security_group" "sg_web" {
  name = "vpc_test_web"
  description = "Allow incoming HTTP connection & RDP access"

  ingress {
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
      Name = "Web Server SG"
  }
}

# Define Security group for private subnet
resource "aws_security_group" "sg_db" {
  name = "sg_test_web"
  description = "Allow traffic from public subnet"

  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
      from_port = 3389
      to_port = 3389
      protocol = "tcp"
      cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
      Name = "DB SG"
  }
}

