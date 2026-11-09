# Variables para el módulo DynamoDB
# Este archivo define las variables necesarias para configurar
# una tabla DynamoDB con sus atributos y GSIs.

variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "billing_mode" {
  description = "Modo de facturación para la tabla DynamoDB (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Clave hash (partition key) para la tabla DynamoDB"
  type        = string
}

variable "hash_key_type" {
  description = "Tipo de dato de la clave hash (S para string, N para number)"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Clave de rango (sort key) para la tabla DynamoDB"
  type        = string
  default     = null
}

variable "range_key_type" {
  description = "Tipo de dato de la clave de rango (S para string, N para number)"
  type        = string
  default     = "S"
}

variable "attributes" {
  description = "Lista de atributos para la tabla DynamoDB"
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "gsi" {
  description = "Lista de GSI para la tabla DynamoDB"
  type = list(object({
    name            = string
    hash_key       = string
    hash_key_type  = string
    range_key      = string
    range_key_type = string
    projection_type = string
  }))
  default = []
}

variable "tags" {
  description = "Tags para la tabla DynamoDB"
  type        = map(string)
  default     = {}
}

variable "ttl_attribute" {
  description = "Atributo para TTL (Time To Live) en la tabla DynamoDB"
  type        = string
  default     = null
}

variable "stream_enabled" {
  description = "Habilita el stream para la tabla DynamoDB"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Tipo de vista para el stream (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = null
}