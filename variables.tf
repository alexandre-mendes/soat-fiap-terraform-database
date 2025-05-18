variable "aws_access_key" {
  description = "AWS Access Key temporária (Academy)"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key temporária (Academy)"
  type        = string
}

variable "aws_session_token" {
  description = "AWS Session Token temporário (Academy)"
  type        = string
}

variable "tabelas" {
  description = "Mapa de tabelas DynamoDB"
  type = map(object({
    hash_key = string
    attributes = list(object({
      name = string
      type = string
    }))
  }))
}

