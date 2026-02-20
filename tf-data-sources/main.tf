terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "6.30.0"
      }
    }
    backend "s3" {
        bucket = "terraform-state-s3-abzq"
        key = "test/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
    }
}

provider "aws" {
    region = "ap-south-1"
    alias = "south"
}

provider "aws" {
    region = "ap-north-1"
    alias = "north"
}

locals {
  instance_type = "t3.micro"
}

data "aws_vpc" "existing" {
  filter {
    name = "tag:Name"
    values = ["my_vpc"]
  }
}

data "aws_subnet" "existing" {
  filter {
    name = "cidr-block"
    values = ["10.1.2.0/24"]
  }
}

#to destroy a specific resource use -target=<resource>.<reource-local-name>
resource "aws_instance" "new-public" {
  ami = "ami-0ff5003538b60d5ec"
  provider = aws.south
  subnet_id = data.aws_subnet.existing.id
  instance_type = local.instance_type

  tags = {
    Name = "new-public"
  }
}

output "vpc-id" {
  value = data.aws_vpc.existing.id
}

output "subnet-id" {
  value = data.aws_subnet.existing.id
}

output "instance-ip" {
  value = aws_instance.new-public.private_ip
}