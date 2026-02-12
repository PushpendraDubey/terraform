terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}

provider "aws" {
    region = "ap-south-01"
}

data "aws_ami" "linux" {
  most_recent = true
  owners = [amazon]

  filter {
    name = "name"
    values = "al2023-ami-2023*"
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "name" {
  ami = data.aws_ami.linux.id
  instance_type = var.aws_instance_type

  root_block_device {
    delete_on_termination = true
    volume_size = var.root_volume_size
    volume_type = var.root_volume_size
  }

  tags = {
    Name = "my-instance"
  }
}