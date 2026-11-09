# Order Management API

API REST para gestión de órdenes sobre DynamoDB.

## Requisitos Previos

- Node.js 22
- npm 10+
- AWS CLI configurado (para pruebas locales con DynamoDB)

## Instalación

```bash
npm install
```

## Configuración

Crear archivo `.env` en la raíz del proyecto:

```env
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
DYNAMODB_TABLE=orders
DYNAMODB_ENDPOINT=http://localhost:8000
PORT=3000
```

## Compilación

```bash
npm run build
```

## Ejecución

### Desarrollo
```bash
npm run dev
```

### Producción
```bash
npm start
```

El servidor estará disponible en `http://localhost:3000`

## Pruebas

### Todas las pruebas
```bash
npm test
```

### Solo pruebas unitarias
```bash
npm run test:unit
```

### Solo pruebas de integración
```bash
npm run test:integration
```

## API Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | /orders | Crear nueva orden |
| GET | /orders/:id | Obtener orden por ID |
| PUT | /orders/:id | Actualizar orden existente |
| DELETE | /orders/:id | Eliminar orden |
| GET | /orders | Listar todas las órdenes |

### Request/Response Examples

**POST /orders**
```json
{
  "cliente": "Cliente Ejemplo",
  "producto": "Producto Ejemplo",
  "cantidad": 5,
  "precio": 100.00
}
```

**GET /orders/:id**
```json
{
  "id": "uuid-generado",
  "cliente": "Cliente Ejemplo",
  "producto": "Producto Ejemplo",
  "cantidad": 5,
  "precio": 100.00,
  "fecha": "2024-01-01T00:00:00.000Z"
}
```

## Estructura del Proyecto

```
src/
├── main.ts                      # Punto de entrada
├── domain/
│   ├── models/                  # Entidades y DTOs
│   └── repositories/            # Interfaces de repositorios
├── application/
│   └── services/                # Lógica de negocio
├── infrastructure/
│   ├── controllers/             # Controladores REST
│   ├── repositories/            # Implementaciones de repositorios
│   └── config/                  # Configuración AWS y errores
test/
├── unit/                        # Pruebas unitarias
└── integration/                 # Pruebas de integración
```

## DynamoDB Local

Para desarrollo local, usar DynamoDB local:

```bash
docker run -p 8000:8000 amazon/dynamodb-local
```

Crear tabla:
```bash
aws dynamodb create-table \
  --table-name orders \
  --attribute-definitions AttributeName=id,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --endpoint-url http://localhost:8000
```