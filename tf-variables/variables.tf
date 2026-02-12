variable "aws_instance_type" {
  description = "What type of instance do you want?"
  type = string
  validation {
    condition = var.aws_instance_type=="t2.micro" || var.aws_instance_type=="t3.micro"
    error_message = "Only t2.micro and t3.micro types are allowed!!"
  }
}

variable "root_volume_size" {
  type = number
  default = 20
}

variable "root_volume_type" {
  type = string
  default = "gp2"
}