resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  stream_enabled = var.enable_stream
  stream_view_type = var.stream_view_type

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "hash_key" {
    for_each = var.hash_key != null ? [var.hash_key] : []
    content {
      attribute_name = hash_key.value.name
      attribute_type = hash_key.value.type
    }
  }

  dynamic "range_key" {
    for_each = var.range_key != null ? [var.range_key] : []
    content {
      attribute_name = range_key.value.name
      attribute_type = range_key.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.gsi
    content {
      name            = gsi.value.name
      hash_key        = gsi.value.hash_key
      range_key       = lookup(gsi.value, "range_key", null)
      projection_type = gsi.value.projection_type
      read_capacity   = lookup(gsi.value, "read_capacity", null)
      write_capacity  = lookup(gsi.value, "write_capacity", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.lsi
    content {
      name            = lsi.value.name
      hash_key        = var.hash_key[0].name
      range_key       = lsi.value.range_key
      projection_type = lookup(lsi.value, "projection_type", "KEYS_ONLY")
    }
  }

  dynamic "point_in_time_recovery" {
    for_each = var.enable_pitr ? [1] : []
    content {
      enabled = true
    }
  }

  dynamic "server_side_encryption" {
    for_each = var.enable_sse ? [1] : []
    content {
      enabled     = true
      kms_key_arn = var.kms_key_arn
    }
  }

  ttl {
    attribute_name = var.ttl_attribute
    enabled        = var.enable_ttl
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_dynamodb_table_replica" "this" {
  count = var.replica_regions != null ? length(var.replica_regions) : 0

  provider = aws.dynamodb_replica[count.index]

  table_name = aws_dynamodb_table.this.name
  kms_key_arn = lookup(var.replica_regions[count.index], "kms_key_arn", null)
}

resource "aws_dynamodb_tag" "this" {
  for_count = length(var.tags)
  resource = aws_dynamodb_table.this.arn
  key      = keys(var.tags)[count.index]
  value    = values(var.tags)[count.index]
}