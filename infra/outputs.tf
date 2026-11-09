# =============================================================================
# SALIDAS DE LA CONFIGURACIÓN DE INFRAESTRUCTURA
# =============================================================================
# Este archivo exporta los valores críticos de la infraestructura creada
# para que puedan ser consumidos por otros módulos de Terraform o por
# la aplicación que utiliza esta infraestructura.
# =============================================================================

# -----------------------------------------------------------------------------
# SALIDAS DE LA TABLA DYNAMODB
# -----------------------------------------------------------------------------

# ARN completo de la tabla DynamoDB
# Se usa para permisos IAM y referencia en otros recursos
output "dynamodb_table_arn" {
  description = "ARN completo de la tabla DynamoDB de órdenes"
  value       = module.dynamodb_orders.table_arn
}

# Nombre de la tabla DynamoDB
# Se usa para conectar la aplicación con la tabla
output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB de órdenes"
  value       = module.dynamodb_orders.table_name
}

# ID de la tabla DynamoDB
# Identificador único de la tabla en la región
output "dynamodb_table_id" {
  description = "ID de la tabla DynamoDB de órdenes"
  value       = module.dynamodb_orders.table_id
}

# ARN del stream de DynamoDB
# Se usa para configurar Lambda que procesa cambios en las órdenes
output "dynamodb_table_stream_arn" {
  description = "ARN del stream de DynamoDB para captura de cambios"
  value       = module.dynamodb_orders.table_stream_arn
}

# Estado de la tabla
# Indica si la tabla está activa o en proceso de creación
output "dynamodb_table_status" {
  description = "Estado actual de la tabla DynamoDB"
  value       = module.dynamodb_orders.table_status
}

# -----------------------------------------------------------------------------
# SALIDAS DE SEGURIDAD Y ACCESO
# -----------------------------------------------------------------------------

# ID del grupo de seguridad creado para acceso a DynamoDB
output "security_group_id" {
  description = "ID del grupo de seguridad para acceso a DynamoDB"
  value       = aws_security_group.dynamodb_access.id
}

# ARN de la política de acceso a DynamoDB
output "dynamodb_policy_arn" {
  description = "ARN de la política de acceso a DynamoDB"
  value       = aws_iam_policy.dynamodb_access_policy.arn
}

# Nombre de la política de acceso
output "dynamodb_policy_name" {
  description = "Nombre de la política de acceso a DynamoDB"
  value       = aws_iam_policy.dynamodb_access_policy.name
}

# -----------------------------------------------------------------------------
# SALIDAS DE MONITOREO
# -----------------------------------------------------------------------------

# ARN de la alarma de throttling
output "throttle_alarm_arn" {
  description = "ARN de la alarma de CloudWatch para throttling"
  value       = aws_cloudwatch_metric_alarm.dynamodb_throttle.arn
}

# Nombre de la alarma de throttling
output "throttle_alarm_name" {
  description = "Nombre de la alarma de CloudWatch para throttling"
  value       = aws_cloudwatch_metric_alarm.dynamodb_throttle.alarm_name
}

# -----------------------------------------------------------------------------
# SALIDOS DE INFORMACIÓN GENERAL
# -----------------------------------------------------------------------------

# Región donde se desplegó la infraestructura
output "aws_region" {
  description = "Región de AWS donde se desplegó la infraestructura"
  value       = var.aws_region
}

# Entorno de despliegue
output "environment" {
  description = "Entorno donde se desplegó la infraestructura (dev, staging, prod)"
  value       = var.environment
}

# Prefijo de recursos utilizado
output "resource_prefix" {
  description = "Prefijo utilizado para nombrar los recursos"
  value       = "fintech-${var.environment}"
}

# Endpoint de DynamoDB (útil para desarrollo local con LocalStack)
output "dynamodb_endpoint" {
  description = "Endpoint de DynamoDB para la tabla de órdenes"
  value       = "https://dynamodb.${var.aws_region}.amazonaws.com"
}

# URL completa de la tabla para configuración de aplicaciones
output "dynamodb_table_url" {
  description = "URL de la consola de DynamoDB para la tabla de órdenes"
  value       = "https://console.aws.amazon.com/dynamodb/home?region=${var.aws_region}#tables:selected=${module.dynamodb_orders.table_name}"
}

# -----------------------------------------------------------------------------
# EXPORTACIÓN PARA CONSUMO EXTERNO
# -----------------------------------------------------------------------------

# Objeto consolidado con información de conexión para la aplicación
output "connection_info" {
  description = "Información de conexión consolidada para la aplicación"
  value = {
    region         = var.aws_region
    table_name     = module.dynamodb_orders.table_name
    table_arn      = module.dynamodb_orders.table_arn
    endpoint       = "https://dynamodb.${var.aws_region}.amazonaws.com"
    stream_arn     = module.dynamodb_orders.table_stream_arn
    environment    = var.environment
    policy_arn     = aws_iam_policy.dynamodb_access_policy.arn
    security_group = aws_security_group.dynamodb_access.id
  }
}