# Infraestructura Terraform - Gestión de Órdenes DynamoDB

Este directorio contiene la configuración de infraestructura como código para el sistema de gestión de órdenes en la plataforma fintech. La infraestructura se despliega utilizando Terraform con el proveedor de AWS.

## Requisitos Previos

Antes de ejecutar cualquier comando de Terraform, asegúrese de tener instalado:

- **Terraform** versión 1.9 o superior
- **AWS CLI** configurado con credenciales válidas
- **Permisos IAM** suficientes para crear recursos en AWS (dynamodb:*, iam:*, etc.)

La configuración de credentials de AWS puede realizarse de las siguientes formas:

1. Variables de entorno: `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`
2. Archivo de credenciales: `~/.aws/credentials`
3. Perfil nombrado: `aws configure --profile nombre-perfil`
4. Roles de IAM en entornos ECS/EC2

## Estructura del Directorio

```
infra/
├── environments/
│   └── dev/
│       └── terraform.tfvars    # Variables específicas del entorno de desarrollo
├── modules/
│   └── dynamodb/
│       ├── main.tf             # Definición del módulo de DynamoDB
│       ├── variables.tf        # Variables del módulo
│       └── outputs.tf          # Salidas del módulo
├── providers.tf                # Configuración del proveedor AWS
├── versions.tf                 # Requisitos de versión de Terraform y proveedores
├── variables.tf                # Variables globales del proyecto
├── main.tf                     # Archivo principal que orquesta los recursos
└── outputs.tf                  # Salidas globales del proyecto
```

## Configuración por Ambiente

La infraestructura soporta múltiples ambientes mediante el uso de archivos de variables de Terraform. Cada ambiente tiene su propio directorio bajo `environments/`:

- **dev**: Entorno de desarrollo para pruebas locales
- **staging**: Entorno de pre-producción
- **prod**: Entorno de producción

## Flujo de Trabajo Recomendado

### Inicialización del Proyecto

El primer paso es inicializar el backend de Terraform y descargar los proveedores necesarios:

```bash
cd infra
terraform init
```

Este comando descarga el proveedor AWS versión 5.69.0 y configura el backend de estado local. Para entornos de producción se recomienda utilizar un backend remoto como S3 con bloqueo mediante DynamoDB.

### Validación de la Configuración

Antes de aplicar cualquier cambio, es fundamental validar que la configuración de Terraform sea correcta syntax y semánticamente:

```bash
terraform validate
```

Este comando verifica que todos los archivos de configuración sean válidos, que las referencias entre recursos sean correctas y que las expresiones de Terraform estén bien formadas.

### Planificación de Cambios

El comando `terraform plan` muestra los cambios que se aplicarán sin ejecutarlos. Es una práctica obligatoria revisar esta salida antes de aplicar cualquier modificación:

```bash
terraform plan -var-file=environments/dev/terraform.tfvars
```

La planificación muestra claramente qué recursos se crearán, modificarán o destruirán. En nuestro caso, el plan debería indicar la creación de una tabla DynamoDB con los atributos necesarios para almacenar órdenes.

### Aplicación de Cambios

Una vez revisado el plan y confirmado que los cambios son los esperados, se aplica la infraestructura:

```bash
terraform apply -var-file=environments/dev/terraform.tfvars
```

Terraform solicita confirmación antes de proceder. Para automatización, se puede usar la bandera `-auto-approve` aunque no se recomienda en entornos de producción.

### Destrucción de Recursos

Para eliminar todos los recursos creados por Terraform:

```bash
terraform destroy -var-file=environments/dev/terraform.tfvars
```

**Advertencia**: Esta operación es irreversible. Asegúrese de que no hay datos importantes en los recursos que serán destruidos, especialmente en el caso de DynamoDB donde los datos se pierden definitivamente.

## Tabla DynamoDB - Detalles de Implementación

La tabla de órdenes está diseñada con las siguientes características optimizadas para el caso de uso del sistema fintech:

### Clave de Partición y Ordenación

La tabla utiliza `order_id` como clave de partición (partition key) y `created_at` como clave de ordenación (sort key). Esta estructura permite consultas eficientes por ID de orden individual y consultas rango por fecha de creación.

### Índices Globales Secundarios (GSI)

Se configuran dos GSI para soportar diferentes patrones de consulta:

1. **GSI por cliente**: Permite consultar todas las órdenes de un cliente específico eficientemente. La clave de partición es `customer_id`.

2. **GSI por producto**: Permite consultar órdenes que contienen un producto específico. La clave de partición es `product_id`.

### Modo de Facturación

La tabla utiliza modo de facturación `PAY_PER_REQUEST` para optimizar costos en entornos con tráfico variable, común en aplicaciones fintech donde el volumen de transacciones puede variar significativamente.

### Cifrado

Los datos en reposo están cifrados utilizando AWS managed keys (AWSOwnedKeys) por defecto, proporcionando seguridad sin costo adicional.

## Variables de Configuración

El archivo `terraform.tfvars` contiene los valores específicos del ambiente. Las variables principales incluyen:

- **environment**: Nombre del ambiente (dev, staging, prod)
- **region**: Región de AWS donde se desplegará la infraestructura
- **table_name**: Nombre de la tabla DynamoDB
- **billing_mode**: Modo de facturación (PAY_PER_REQUEST o PROVISIONED)
- **read_capacity** y **write_capacity**: Capacidades aprovisionadas (solo si se usa modo PROVISIONED)

##Outputs

Después de aplicar la infraestructura, Terraform muestra las siguientes salidas:

- **table_name**: Nombre de la tabla DynamoDB creada
- **table_arn**: ARN completo de la tabla para referencia en otras configuraciones
- **table_id**: ID único de la tabla

Estas salidas pueden ser referenciadas en otros módulos de Terraform o utilizadas para configurar la aplicación que accede a la base de datos.

## Integración con la Aplicación

La aplicación backend (implementada en el componente `backend`) se conecta a DynamoDB utilizando las credenciales de AWS configuradas en el entorno. El nombre de la tabla se configura mediante variables de entorno, permitiendo que la misma aplicación pueda conectarse a diferentes tablas según el ambiente.

## Buenas Prácticas

1. **Nunca commitear archivos de estado**: El archivo `terraform.tfstate` contiene información sensible y nunca debe incluirse en el repositorio. Ya está ignorado en `.gitignore`.

2. **Usar workspaces para ambientes**: Terraform workspaces permite gestionar múltiples ambientes con el mismo código. Sin embargo, para este proyecto se prefirió usar directorios separados por claridad.

3. **Versionar el código de infraestructura**: Igual que el código de aplicación, la infraestructura debe estar versionada y pasar por revisión de código antes de aplicarse.

4. **Documentar cambios significativos**: Cualquier cambio en la infraestructura que afecte la operación debe documentarse en el changelog del proyecto.

## Troubleshooting

### Error: No se encuentran credenciales de AWS

Verifique que las credenciales estén correctamente configuradas ejecutando:

```bash
aws sts get-caller-identity
```

Este comando muestra la identidad de AWS asociada a las credenciales activas.

### Error: La tabla ya existe

Si Terraform indica que la tabla ya existe, puede ser que se haya creado manualmente o en una ejecución anterior. Use `terraform import` para importar el recurso existente o elimínelo manualmente desde la consola de AWS.

### Error: Límites de capacidad

Si recibe errores relacionados con límites de capacidad de DynamoDB, verifique los límites de su cuenta AWS y solicite un aumento si es necesario. Para desarrollo puede usar el modo PAY_PER_REQUEST que no requiere capacidad mínima.

## Referencias

- Documentación oficial de Terraform: https://www.terraform.io/docs
- Documentación del proveedor AWS de Terraform: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Mejores prácticas de DynamoDB: https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html