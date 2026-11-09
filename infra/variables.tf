# Variables globales para la configuración de la infraestructura
# Estas variables permiten parametrizar los recursos para diferentes entornos,
# asegurando reutilización y flexibilidad.

# Variables generales
variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nombre del proyecto, usado para nombrar recursos"
  type        = string
  default     = "fintech-orders"
}

# Variables para la tabla DynamoDB
variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB para órdenes"
  type        = string
  default     = "orders-table"
}

variable "dynamodb_billing_mode" {
  description = "Modo de facturación para la tabla DynamoDB (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_hash_key" {
  description = "Clave hash (partition key) para la tabla DynamoDB"
  type        = string
  default     = "orderId"
}

variable "dynamodb_hash_key_type" {
  description = "Tipo de dato de la clave hash (S para string, N para number)"
  type        = string
  default     = "S"
}

variable "dynamodb_range_key" {
  description = "Clave de rango (sort key) para la tabla DynamoDB"
  type        = string
  default     = "createdAt"
}

variable "dynamodb_range_key_type" {
  description = "Tipo de dato de la clave de rango (S para string, N para number)"
  type        = string
  default     = "S"
}

# Atributos adicionales para la tabla DynamoDB
variable "dynamodb_attributes" {
  description = "Lista de atributos adicionales para la tabla DynamoDB"
  type = list(object({
    name = string
    type = string
  }))
  default = [
    {
      name = "clientId"
      type = "S"
    },
    {
      name = "productId"
      type = "S"
    },
    {
      name = "status"
      type = "S"
    },
    {
      name = "amount"
      type = "N"
    }
  ]
}

# Configuración de GSI (Global Secondary Index)
variable "dynamodb_gsi" {
  description = "Lista de GSI para la tabla DynamoDB"
  type = list(object({
    name            = string
    hash_key       = string
    hash_key_type  = string
    range_key      = string
    range_key_type = string
    projection_type = string
  }))
  default = [
    {
      name            = "ClientIndex"
      hash_key       = "clientId"
      hash_key_type  = "S"
      range_key      = "createdAt"
      range_key_type = "S"
      projection_type = "ALL"
    },
    {
      name            = "ProductIndex"
      hash_key       = "productId"
      hash_key_type  = "S"
      range_key      = "createdAt"
      range_key_type = "S"
      projection_type = "ALL"
    }
  ]
}