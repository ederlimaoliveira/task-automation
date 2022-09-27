provider "aws" {
  region     = "us-east-1"
}

resource "tls_private_key" "ec2key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2key.public_key_openssh
}

resource "aws_instance" "c8" {
  ami           = "ami-0c07df890a618c98a"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "c8.local"
  }
  depends_on = [
    aws_key_pair.generated_key
  ]
}

resource "aws_instance" "u21" {
  ami           = "ami-0fcda042dd8ae41c7"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "u21.local"
  }
  depends_on = [
    aws_key_pair.generated_key
  ]
}
