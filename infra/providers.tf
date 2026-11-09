# Configuración de Terraform para el despliegue en AWS
# Este archivo define los providers necesarios para interactuar con AWS
# y establece las versiones requeridas para garantizar compatibilidad.

terraform {
  required_version = ">= 1.9.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

# Configuración del provider AWS
# Utiliza variables para la región y el perfil de AWS,
# permitiendo flexibilidad en diferentes entornos (dev, staging, prod).
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  
  # Configuración de endpoints para DynamoDB y otros servicios
  # útil en entornos locales con LocalStack o similares.
  endpoints {
    dynamodb = var.dynamodb_endpoint
  }
  
  # Configuración para evitar la creación de recursos reales en entornos de prueba
  skip_credentials_validation = var.skip_credentials_validation
  skip_requesting_account_id  = var.skip_requesting_account_id
  skip_metadata_api_check     = var.skip_metadata_api_check
}

# Variables utilizadas en el provider AWS
# Estas variables permiten personalizar la configuración del provider
# para diferentes entornos.
variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Perfil de AWS CLI configurado para autenticación"
  type        = string
  default     = "default"
}

variable "dynamodb_endpoint" {
  description = "Endpoint para DynamoDB, útil para entornos locales como LocalStack"
  type        = string
  default     = null
}

variable "skip_credentials_validation" {
  description = "Omite la validación de credenciales en entornos de prueba"
  type        = bool
  default     = false
}

variable "skip_requesting_account_id" {
  description = "Omite la solicitud del account ID en entornos de prueba"
  type        = bool
  default     = false
}

variable "skip_metadata_api_check" {
  description = "Omite la verificación de la API de metadatos en entornos de prueba"
  type        = bool
  default     = false
}