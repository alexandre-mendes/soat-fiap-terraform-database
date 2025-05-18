terraform {
backend "s3" {
    bucket         = "soat-terraform-state-2025"
    key            = "dynamo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

provider "aws" {
  region     = "us-east-1"
}

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
