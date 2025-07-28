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

variable "db_master_password" {
  description = "A senha mestre para o cluster Aurora."
  type        = string
  sensitive   = true
}
