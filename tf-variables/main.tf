terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
}

data "aws_ami" "linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_vpc" "existing-vpc" {
  id = "vpc-016d52122066362f1"
}
data "aws_subnet" "existing-subnet" {
  id = "subnet-0490fb14715fb4970"
}

resource "aws_instance" "my-instance" {
  ami = data.aws_ami.linux.id
  instance_type = var.aws_instance_type
  subnet_id = data.aws_subnet.existing-subnet.id

  root_block_device {
    delete_on_termination = true
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = {
    Name = "my-private-instance"
  }
}

output "private-ip" {
  value = aws_instance.my-instance.private_ip
}