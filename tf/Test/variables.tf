variable "aws_region" {
  description = "Region for the VPC"
  default = "ap-southeast-2"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for public subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for private subnet"
    default = "10.0.2.0/24"  
}

variable "key_path" {
  description = "SSH Public Key Path"
  default = "C:\\Users\\skharat\\Documents\\Terraform\\samples\\Keys\\aws_test.pem"
}

variable "ami" {
  description = "Amazon Windows AMI"
  default = "ami-0096a7a7add65af89"
}
