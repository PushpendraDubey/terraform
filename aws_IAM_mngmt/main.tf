terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.54.1"
    }
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
  users_data = yamldecode(file("./users.yaml")).users

  user_role_pair = flatten([for user in local.users_data: [for role in user.roles: {
    username = user.username
    role = role
  }]])
}

output "output" {
  value = local.users_data[*].username
}

resource "aws_iam_user" "users" {
  provider = aws.south
  for_each = toset(local.users_data[*].username)
  name = each.value
}

resource "aws_iam_user_login_profile" "profile" {
  for_each = aws_iam_user.users
  user = each.value.name
  password_length = 10

  lifecycle {
    ignore_changes = [ 
        password_length,
        password_reset_required,
        pgp_key,
     ]
  }
}

resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.local.user_role_pair:
    "${pair.username}-${pair.role}" => pair
  }
  user = aws_iam_user.users[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}