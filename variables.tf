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

