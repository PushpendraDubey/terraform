variable "aws_instance_type" {
  description = "What type of instance do you want?"
}

variable "root_volume_size" {
  type = number
  default = 20
}

variable "root_volume_type" {
  type = string
  default = "gp2"
}