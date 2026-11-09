terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

# Configuración del proveedor de AWS con región por defecto
# La región puede ser sobrescrita mediante variables de entorno
# TF_VAR_aws_region o mediante el archivo terraform.tfvars
provider "aws" {
  region = var.aws_region

  # Configuración de endpoints para desarrollo local con LocalStack
  # Descomenta las siguientes líneas si ejecutas Terraform contra LocalStack
  # endpoints {
  #   dynamodb = "http://localhost:4566"
  # }

  # Configuración de retry para operaciones que pueden fallar transitoriamente
  # Terraform automáticamente reintenta operaciones fallidas por límites de tasa
  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "fintech-orders"
    }
  }
}

# Configuración específica del proveedor para DynamoDB
# Define timeouts predeterminados para operaciones de tabla
provider "aws" {
  alias = "dynamodb"

  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "fintech-orders"
      Component   = "dynamodb"
    }
  }
}

# Validación de región permitida
# AWS tiene regiones específicas donde sus servicios están disponibles
# Esta validación asegura que no se use una región no válida
locals {
  allowed_regions = ["us-east-1", "us-east-2", "us-west-1", "us-west-2", "eu-west-1", "eu-central-1"]

  is_valid_region = contains(local.allowed_regions, var.aws_region)

  region_validation_error = var.aws_region == "" ? "La región de AWS no puede estar vacía" : (
    !local.is_valid_region ? "La región ${var.aws_region} no está en la lista de regiones permitidas: ${join(", ", local.allowed_regions)}" : ""
  )
}

# Validación al inicio de Terraform para asegurar configuración correcta
# Si la región no es válida, Terraform fallará con un error claro
resource "null_resource" "validate_region" {
  count = local.region_validation_error != "" ? 1 : 0

  triggers = {
    error_message = local.region_validation_error
  }
}

# Configuración de backend para estado remoto
# El estado de Terraform se almacena en S3 para compartir entre miembros del equipo
# Esto evita conflictos cuando múltiples personas trabajan en la infraestructura
terraform {
  backend "s3" {
    bucket         = "fintech-terraform-state"
    key            = "infra/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "fintech-terraform-locks"
  }
}