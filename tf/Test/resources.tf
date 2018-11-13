#SSH Keypair for instance
resource "aws_key_pair" "default" {
  key_name = "testkeypair"
  public_key = "${file("${var.key_path}")}"
}

#Define Webserver inside public subnet
resource "aws_instance" "web_server" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_web.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
      Name = "web server"
  }
}

#Define database inside private subnet
resource "aws_instance" "db_server" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.private_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_db.id}"]
  source_dest_check = false

  tags {
      Name = "database server" 
  }
}
