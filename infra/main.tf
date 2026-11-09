# =============================================================================
# CONFIGURACIÓN PRINCIPAL DE INFRAESTRUCTURA
# =============================================================================
# Este archivo contiene la configuración principal de Terraform para el
# despliegue de la infraestructura de la aplicación fintech de gestión de órdenes.
# Utiliza módulos reutilizables para crear recursos de manera modular.
# =============================================================================

# Definición de tags comunes para todos los recursos
# Estos tags se aplican automáticamente a todos los recursos que soporte
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "fintech-orders"
    CostCenter  = "Engineering"
    Team        = "Platform"
  }

  # Nombre estándar para los recursos
  resource_prefix = "fintech-${var.environment}"
}

# -----------------------------------------------------------------------------
# MÓDULO: TABLA DYNAMODB PARA ÓRDENES
# -----------------------------------------------------------------------------
# Este módulo crea la tabla DynamoDB que almacenará las órdenes del sistema.
# La tabla utiliza el ID de la orden como clave de partición (PK).
# Se configuran índices secundarios globales (GSI) para permitir consultas
# eficientes por cliente y por producto.
# -----------------------------------------------------------------------------

module "dynamodb_orders" {
  # Se referencia el módulo local de DynamoDB
  source = "./modules/dynamodb"

  # Nombre de la tabla - se genera automáticamente con prefijo de entorno
  table_name = "${local.resource_prefix}-orders"

  # Clave primaria de la tabla
  # El ID de orden es un UUID único generado por el sistema
  hash_key = "orderId"

  # Tipo de dato de la clave primaria (S = String, N = Number, B = Binary)
  hash_key_type = "S"

  # Configuración de capacidad de lectura y escritura
  # On-Demand: paga por lo que usa, ideal para desarrollo y cargas variables
  # Provisioned: capacidad fija, ideal para cargas predecibles
  billing_mode = "PAY_PER_REQUEST"

  # Atributos de la tabla - necesarios para definir la clave y GSI
  attributes = [
    {
      name = "orderId"
      type = "S"
    },
    {
      name = "customerId"
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
      name = "createdAt"
      type = "S"
    }
  ]

  # Índices secundarios globales (GSI) para consultas eficientes
  # GSI1: Consulta por customerId para obtener todas las órdenes de un cliente
  global_secondary_indexes = [
    {
      name            = "CustomerIdIndex"
      hash_key        = "customerId"
      hash_key_type   = "S"
      projection_type = "ALL"
      # Para modo on-demand no se especifica read/write capacity
    },
    {
      name            = "ProductIdIndex"
      hash_key        = "productId"
      hash_key_type   = "S"
      projection_type = "ALL"
    },
    {
      name            = "StatusCreatedAtIndex"
      hash_key        = "status"
      hash_key_type   = "S"
      range_key       = "createdAt"
      range_key_type  = "S"
      projection_type = "ALL"
    }
  ]

  # Habilitar Streaming de DynamoDB para captura de cambios (CDC)
  # Esto permite que otras partes del sistema reactúen a cambios en las órdenes
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  # Configuración de Time-To-Live (TTL)
  # Las órdenes se eliminan automáticamente después de 90 días
  # Esto ayuda a gestionar costos de almacenamiento
  ttl_enabled      = true
  ttl_attribute_name = "ttl"

  # Servidor-side encryption con AWS managed key
  server_side_encryption_enabled = true
  sse_type                         = "AES256"

  # Tags específicos para el módulo
  tags = merge(local.common_tags, {
    Description = "Tabla DynamoDB para almacenar órdenes del sistema fintech"
    Component   = "DynamoDB"
    DataClassification = "Confidential"
  })
}

# -----------------------------------------------------------------------------
# CONFIGURACIÓN ADICIONAL DE INFRAESTRUCTURA
# -----------------------------------------------------------------------------

# Grupo de seguridad para el acceso a DynamoDB desde la VPC
# Este grupo define las reglas de acceso a los recursos de AWS
resource "aws_security_group" "dynamodb_access" {
  name        = "${local.resource_prefix}-dynamodb-access"
  description = "Grupo de seguridad para acceso a DynamoDB"
  vpc_id      = var.vpc_id

  # Reglas de egress permitidas
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir todo el tráfico saliente"
  }

  tags = merge(local.common_tags, {
    Name = "${local.resource_prefix}-dynamodb-access"
  })
}

# Política de acceso a la tabla DynamoDB
# Esta política permite a los recursos de la VPC acceder a la tabla
resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = "${local.resource_prefix}-dynamodb-access-policy"
  description = "Política de acceso a la tabla de órdenes en DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          module.dynamodb_orders.table_arn,
          "${module.dynamodb_orders.table_arn}/index/*"
        ]
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.resource_prefix}-dynamodb-access-policy"
  })
}

# Alarma de CloudWatch para monitoreo de throttling
# Notifica cuando hay limitaciones de tasa en la tabla
resource "aws_cloudwatch_metric_alarm" "dynamodb_throttle" {
  alarm_name          = "${local.resource_prefix}-dynamodb-throttle"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ThrottledRequests"
  namespace           = "AWS/DynamoDB"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Alarma cuando hay throttle en DynamoDB"

  dimensions = {
    TableName = module.dynamodb_orders.table_name
  }

  tags = merge(local.common_tags, {
    Name = "${local.resource_prefix}-dynamodb-throttle"
  })
}