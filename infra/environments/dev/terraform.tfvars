# ==============================================================================
# Variables de configuración para el entorno de DESARROLLO
# ==============================================================================
# Este archivo contiene los valores específicos del ambiente de desarrollo.
# NO incluir valores sensibles como claves o secretos en este archivo.
# Utilizar variables de entorno de Terraform para datos sensibles.
# ==============================================================================

# ------------------------------------------------------------------------------
# Configuración General del Ambiente
# ------------------------------------------------------------------------------

# Nombre del ambiente de despliegue. Se utiliza para identificar recursos
# en la consola de AWS y para reglas de nomenclatura.
environment = "dev"

# Región de AWS donde se desplegarán los recursos. Usar región cercana
# a la ubicación de los desarrolladores para minimizar latencia.
aws_region = "us-east-1"

# Tags adicionales que se aplicarán a todos los recursos creados.
# Incluir tags de costo, propietario y ambiente para facilitar la gestión.
common_tags = {
  Environment = "development"
  ManagedBy   = "terraform"
  Project     = "fintech-orders"
  Owner       = "platform-team"
  CostCenter  = "engineering"
}

# ------------------------------------------------------------------------------
# Configuración de DynamoDB
# ------------------------------------------------------------------------------

# Nombre de la tabla DynamoDB. Se recomienda incluir el ambiente en el nombre
# para evitar colisiones entre ambientes. Longitud máxima: 255 caracteres.
table_name = "fintech-orders-dev"

# Descripción de la tabla para documentación interna.
table_description = "Tabla de órdenes para el sistema de gestión de órdenes fintech - Ambiente de Desarrollo"

# Modo de facturación de la tabla. PAY_PER_REQUEST es ideal para desarrollo
# y ambientes con tráfico variable. PROVISIONED es mejor para producción
# con tráfico predecible.
# Valores válidos: PAY_PER_REQUEST, PROVISIONED
billing_mode = "PAY_PER_REQUEST"

# Capacidad de lectura aprovisionada (solo aplica si billing_mode = PROVISIONED).
# Representa el número de unidades de lectura por segundo.
# 5 RCU es suficiente para desarrollo básico.
read_capacity = 5

# Capacidad de escritura aprovisionada (solo aplica si billing_mode = PROVISIONED).
# Representa el número de unidades de escritura por segundo.
# 5 WCU es suficiente para desarrollo básico.
write_capacity = 5

# Habilitar transmisión de streams de DynamoDB para captura de cambios.
# Útil para arquitecturas basadas en eventos y replicación.
# Valores: STREAM_NEW_IMAGE, STREAM_OLD_IMAGE, STREAM_NEW_AND_OLD_IMAGES, STREAM_KEYS_ONLY
enable_streams = true
stream_view_type = "NEW_AND_OLD_IMAGES"

# Habilitar Point-in-Time Recovery (PITR) para recuperación ante desastres.
# Recomendado para producción; opcional en desarrollo para reducir costos.
enable_point_in_time_recovery = false

# ------------------------------------------------------------------------------
# Configuración de Índices Globales Secundarios (GSI)
# ------------------------------------------------------------------------------

# Configuración del GSI para consultas por cliente.
# Permite consultas eficientes de todas las órdenes de un cliente específico.
gsi_customer_enabled = true
gsi_customer_name = "customer_id-index"
gsi_customer_partition_key = "customer_id"
gsi_customer_projection_type = "ALL"

# Configuración del GSI para consultas por producto.
# Permite consultas eficientes de órdenes que contienen un producto específico.
gsi_product_enabled = true
gsi_product_name = "product_id-index"
gsi_product_partition_key = "product_id"
gsi_product_projection_type = "ALL"

# ------------------------------------------------------------------------------
# Configuración de Time-to-Live (TTL)
# ------------------------------------------------------------------------------

# Habilitar TTL para eliminación automática de órdenes antiguas.
# Útil para cumplir políticas de retención de datos.
# El atributo TTL debe ser un timestamp Unix epoch.
enable_ttl = false
ttl_attribute_name = "expires_at"

# ------------------------------------------------------------------------------
# Configuración de Seguridad
# ------------------------------------------------------------------------------

# Habilitar cifrado en reposo utilizando claves gestionadas por AWS.
# AWS owned keys es la opción más económica para desarrollo.
# Valores: AWS_OWNED_KEYS, CUSTOMER_MANAGED_KEYS, KMS
server_side_encryption = "AWS_OWNED_KEYS"

# Habilitar modo de flujo de datos encriptado para streams.
# Solo aplica si enable_streams es true.
stream_encryption_enabled = false

# ------------------------------------------------------------------------------
# Configuración de Red (opcional para desarrollo local)
# ------------------------------------------------------------------------------

# Habilitar endpoint de VPC para acceso privado a DynamoDB.
# Recomendado para producción; en desarrollo se usa acceso público.
enable_vpc_endpoint = false

# Lista de IDs de VPC donde se creará el endpoint de DynamoDB.
# Solo aplica si enable_vpc_endpoint es true.
vpc_ids = []

# ------------------------------------------------------------------------------
# Configuración de Backups
# ------------------------------------------------------------------------------

# Habilitar backups continuos con On-Demand Backup.
# Recomendado para producción; opcional en desarrollo.
enable_on_demand_backup = false

# Política de retención de backups on-demand en días.
# Solo aplica si enable_on_demand_backup es true.
backup_retention_days = 7

# ------------------------------------------------------------------------------
# Notas de Configuración
# ------------------------------------------------------------------------------
# Este archivo está pensado para el entorno de desarrollo. Los valores aquí
# definidos pueden diferir de producción para optimización de costos y
# facilidad de pruebas. No utilizar en entornos de staging o producción
# sin revisar y ajustar los valores apropiadamente.
#
# Para ambiente de staging, crear: environments/staging/terraform.tfvars
# Para ambiente de producción, crear: environments/prod/terraform.tfvars
#
# Los valores sensibles como claves KMS oARNs de recursos compartidos
# deben configurarse mediante variables de entorno de Terraform o
# mediante AWS Secrets Manager, nunca hardcodeados en archivos tfvars.
# ------------------------------------------------------------------------------