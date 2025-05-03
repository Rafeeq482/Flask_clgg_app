provider "aws" {
  region = "ap-south-1"
}

#Key pair

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("flaskappkey.pub")
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
  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/startup.log 2>&1
    set -x

    # Wait a bit for network to be ready
    sleep 10

    sudo apt update -y
    sudo apt install -y python3-pip git

    # Clone repo
    git clone https://github.com/Rafeeq482/Flask_clgg_app.git /home/ubuntu/Flask_clgg_app

    # Navigate into the repo
    cd /home/ubuntu/Flask_clgg_app || exit 1
      sudo pip3 install -r requirements.txt
      sudo apt install python3-flask -y

    # Run the app on port 80
    sudo nohup python3 main.py --host=0.0.0.0 --port=80 > output.log 2>&1 &
  EOF



  root_block_device {
    volume_size           = 8
    delete_on_termination = true
    volume_type           = "gp3"
  }
  tags = {
    Name = "Flask_clgg_app"
  }
}