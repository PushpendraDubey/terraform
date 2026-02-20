module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.2.0"

  name = "single-instance"

  instance_type = "t2.micro"
  ami = "ami-06352e7e183818"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id     = module.vpc.public_subnets[0]

  tags = {
    Name  = "module-project"
    Environment = "dev"
  }
}