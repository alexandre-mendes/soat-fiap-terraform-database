terraform {
  backend "s3" {
    bucket  = "soat-terraform-state-5dc9264c8c230a834fe2a59b744523fd"
    key     = "dynamo/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}


//Aurora
data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnet" "subnet" {
  for_each = data.aws_subnets.subnets.ids
  id       = each.value
}

//Dynamo
resource "aws_dynamodb_table" "multi" {
  for_each     = var.tabelas
  name         = each.key
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = each.value.hash_key

  dynamic "attribute" {
    for_each = each.value.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
}
