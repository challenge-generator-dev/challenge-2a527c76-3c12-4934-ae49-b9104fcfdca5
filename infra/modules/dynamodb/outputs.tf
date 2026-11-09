output "table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "ARN completo de la tabla DynamoDB"
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "Identificador único de la tabla"
  value       = aws_dynamodb_table.this.id
}

output "stream_arn" {
  description = "ARN del stream de DynamoDB si está habilitado"
  value       = try(aws_dynamodb_table.this.stream[0].stream_arn, null)
  sensitive   = false
}

output "table_size_bytes" {
  description = "Tamaño de la tabla en bytes"
  value       = aws_dynamodb_table.this.table_size_bytes
}

output "item_count" {
  description = "Cantidad de items en la tabla"
  value       = aws_dynamodb_table.this.item_count
}

output "global_secondary_index_names" {
  description = "Nombres de los índices secundarios globales"
  value       = [for gsi in aws_dynamodb_table.this.global_secondary_index : gsi.name]
}

output "local_secondary_index_names" {
  description = "Nombres de los índices secundarios locales"
  value       = [for lsi in aws_dynamodb_table.this.local_secondary_index : lsi.name]
}

output "replica_table_arns" {
  description = "ARNs de las réplicas de la tabla"
  value       = [for replica in aws_dynamodb_table_replica.this : replica.replica_table_arn]
}

output "billing_mode" {
  description = "Modo de facturación de la tabla"
  value       = aws_dynamodb_table.this.billing_mode
}

output "table_status" {
  description = "Estado actual de la tabla"
  value       = aws_dynamodb_table.this.table_status
}