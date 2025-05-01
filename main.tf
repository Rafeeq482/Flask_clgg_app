provider "aws" {
  region = "ap-south-1"
}

#Key pair

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("terrakey-ec2.pub")
}

resource "aws_key_pair" "new_key" {
  key_name   = "demokey"
  public_key = file("terrakey-ec2.pub")
}



#vpc

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id # interpolation

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ec2

resource "aws_instance" "my_instance" {

  ami             = "ami-0e35ddab05955cf57"
  key_name        = aws_key_pair.deployer.key_name
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my_security_group.name]
  user_data       = file("app.sh")

  root_block_device {
    volume_size           = 8
    delete_on_termination = true
    volume_type           = "gp3"
  }
  tags = {
    Name = "Flask_college project"
  }
}