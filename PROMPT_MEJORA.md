# Prompt para Mejorar el Codigo Base

Copia y pega el contenido del bloque de abajo en un asistente de IA (Claude, ChatGPT)
para obtener el proyecto completo y arrancable. Guarda los archivos que te devuelva en la
carpeta del repo, respetando exactamente las rutas.

Si preferis trabajar en tu editor con un agente local (Claude Code, Cursor, Copilot), usa `AGENTS.md` en vez de este archivo: dice lo mismo pero para que escriba los archivos en disco.

## Las dos reglas que no se negocian

1. **Completa el boilerplate.** Todo lo que el proyecto necesita para compilar y arrancar: manifiesto de dependencias, punto de entrada, configuracion, capa de interfaz, y las capas del patron arquitectonico declarado. Eso es andamiaje y es tu trabajo.
2. **NO resuelvas el reto.** Los entregables de las fases son el trabajo de la persona. El hueco pedagogico se deja como esta: el proyecto arranca, pero lo que el reto pide implementar NO esta implementado.

Dicho de otra forma: si algo impide compilar, arreglalo. Si algo es logica de negocio incompleta, validaciones ausentes, un secreto hardcodeado o un patron mejorable, dejalo exactamente como esta — es lo que la persona tiene que encontrar.

## Superficie de practica — NO resuelvas

Estos archivos SON el ejercicio de la persona. No los implementes; deja stubs.

- `app/test/unit/OrderService.test.ts` — El topic pide TDD/pruebas: este archivo es el ejercicio.
- `app/test/integration/OrderController.test.ts` — El topic pide TDD/pruebas: este archivo es el ejercicio.

## Mapa de componentes

El repo tiene una carpeta por componente. Cada uno se instala y verifica dentro de la suya.

| Componente | Carpeta | Rol | Capa | Track | Tecnologias |
|---|---|---|---|---|---|
| `app` | `app/` | practice, chapter | server | Node | Express, DynamoDB |
| `infra` | `infra/` | support | infra | Terraform (AWS) | Terraform |
| `infra-local` | (raiz) | support | infra | Compose local | DynamoDB |

## Orden de arranque

1. `docker compose up -d` (en la raiz) — levanta la infraestructura local.
2. `cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate` — componente `infra` (support).
3. `cd app && npm install && npm run build` — componente `app` (practice, chapter).

### Contratos entre componentes

- `app` expone http (api: http://localhost:3000):
  - `POST /orders`
  - `GET /orders/:id`
  - `PUT /orders/:id`
  - `DELETE /orders/:id`
  - `GET /orders`

## Herramientas

- **Terraform**: Herramienta de trabajo del candidato: usala en la fase donde se depura o se prueba la solucion (no es una dependencia del proyecto).

## Lo que le falta a este proyecto

Esto NO lo tenes que adivinar: salio de comparar el proyecto contra la arquitectura declarada del reto y de un analisis estatico del codigo. Completalo TODO.

### Boilerplate del stack que falta

Sin esto no compila ni arranca. Es andamiaje, no toca nada de lo pedagogico:

- **app/src/app.module.ts** — Sin el modulo raiz, Nest no tiene arbol de dependencias que resolver y el bootstrap falla.

### Referencias colgando en el codigo que si esta

Cada una rompe la compilacion:

- `app/src/infrastructure/controllers/OrderController.ts` — `OrderService.list`: Se invoca `list` sobre `OrderService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `app/src/infrastructure/controllers/OrderController.ts` — `OrderService.findById`: Se invoca `findById` sobre `OrderService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `app/src/infrastructure/controllers/OrderController.ts` — `OrderService.create`: Se invoca `create` sobre `OrderService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `app/src/infrastructure/controllers/OrderController.ts` — `OrderService.update`: Se invoca `update` sobre `OrderService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `app/src/infrastructure/controllers/OrderController.ts` — `OrderService.delete`: Se invoca `delete` sobre `OrderService`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.
- `app/test/unit/OrderService.test.ts` — `OrderDto.map`: Se invoca `map` sobre `OrderDto`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.

## Como saber que terminaste

```bash
(cd app && npm install && npm run build) && (cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate) && docker compose config -q
```

Ese comando corriendo sin errores es la definicion de "listo".

---

```
## Briefing del reto (autoridad)
Este bloque manda sobre los archivos adjuntos. El stack y el rol salen de AQUÍ, no de un topic genérico ni de markdown placeholder.

### Perfil
Chapter Backend, Especialidad Desarrollador, Tecnología Node, Advanced L2

### Brecha de conocimiento
CRUD de ordenes en DynamoDB expuesto por una API REST (corrida e2e 20261109074436524), Implementa operaciones CRUD de ordenes sobre una tabla DynamoDB expuestas por una API REST

### Misión / candidato
Persistir y consultar ordenes

### Reto
- Tema: CRUD de ordenes sobre DynamoDB
- Seniority: advanced-l2
- Tipo: practical
- Título: Implementación de CRUD de ordenes en DynamoDB
- Tiempo estimado: 8 horas

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Configuración del entorno y creación de la tabla DynamoDB — objetivo: Configurar el entorno de desarrollo y crear la tabla DynamoDB necesaria para almacenar las órdenes. — entregable (NO resolver): Tabla DynamoDB creada y configurada con las columnas necesarias.
- Fase 2: Implementación de la API REST para operaciones CRUD — objetivo: Implementar la API REST que expone las operaciones CRUD sobre la tabla DynamoDB. — entregable (NO resolver): API REST implementada con rutas y controladores para operaciones CRUD sobre la tabla DynamoDB.
- Fase 3: Pruebas y optimización de la API REST — objetivo: Realizar pruebas unitarias y de integración para asegurar la funcionalidad y optimizar el rendimiento de la API REST. — entregable (NO resolver): Pruebas unitarias y de integración escritas y ejecutadas, API REST optimizada.

Eres un asistente experto en análisis, corrección y generación de archivos de cualquier tipo:
código fuente, documentación, hojas de cálculo, documentos Word, configuraciones, entre otros.
Voy a enviarte una cadena de texto que contiene uno o más archivos. Cada archivo está delimitado por un marcador con el siguiente formato:
// === ARCHIVO: ruta/del/archivo.extension ===
o también puede aparecer como:
## === ARCHIVO: ruta/del/archivo.extension ===
Lo que sigue al marcador puede ser:

El contenido real del archivo (código, texto, YAML, etc.)
Una descripción en lenguaje natural de lo que debe contener el archivo


TU TAREA
PASO 0 — ¿Esto es un proyecto o una carcasa?
Antes de extraer archivos, leé el Briefing (si está) y diagnosticá el adjunto.

Es CARCASA si ocurre CUALQUIERA de estas:
- No hay manifiesto de dependencias del stack del briefing (manifest.json de VTEX IO / package.json / pom.xml / build.gradle / requirements.txt / go.mod / *.tf / *.csproj, según corresponda)
- Hay un "binario" que en realidad es un comentario ("no puede ser mostrado como texto plano", placeholder .fig/.docx vacío)
- Los markdowns ya completan entregables de fases posteriores ("se implementó fade-in", lista de áreas ya resuelta)

Si es CARCASA:
- MATERIALIZÁ un proyecto que arranca en el stack del briefing (VTEX IO Store Framework, Angular, Terraform, pytest, Nest, etc.). Incluí manifiesto, punto de entrada y capa de interfaz reales.
- NO copies los markdowns de "solución" como si fueran el producto. Son ruido de generación.
- NO resuelvas las fases del briefing (están marcadas PROHIBIDO). Dejá el hueco pedagógico: el flujo existe, las microinteracciones/calidad/infra que el reto pide NO están hechas.
- Después seguí al PASO 5 (entrega de archivos).

Si es un proyecto REAL (manifiesto + código que compila o arranca):
- Seguí PASO 1 en adelante. 🔴 compilación sí. 🟡 pedagógico no.

PASO 1 — Detección y extracción
Identifica todos los archivos presentes en la cadena. Para cada archivo extrae:

Su ruta completa (ej: src/main/java/com/pragma/Service.java)
Su contenido o descripción

PASO 2 — Clasificación por tipo
Clasifica cada archivo en una de estas categorías:
A) Código fuente (Java, Python, TypeScript, JavaScript, Kotlin, etc.)
B) Configuración / documentación (YAML, properties, Markdown, JSON, txt, etc.)
C) Excel (.xlsx, .xls, .csv)
D) Word (.docx, .doc)
E) Otro tipo de archivo binario o especial
PASO 3 — Clasificación de errores en código fuente

Objetivo prioritario: que el proyecto compile. No corrijas flujo de negocio ni lógica funcional.

Antes de modificar cualquier archivo de código fuente, clasifica cada problema encontrado en una de estas dos categorías:
🔴 ERROR DE COMPILACIÓN — corregir siempre
Son errores que impiden que el proyecto arranque, sin valor pedagógico:

Import faltante o incorrecto
Clase, método o variable referenciada que no existe en ningún archivo del proyecto
Error de sintaxis
Anotación con atributos inválidos
Dependencia ausente en pom.xml, package.json, etc.
Archivo referenciado que no existe y debe ser creado con implementación mínima

→ CORREGIR estos errores.
🟡 PROBLEMA FUNCIONAL O DE CALIDAD — preservar siempre
Son problemas que no impiden compilar. Pueden ser intencionales para el aprendizaje:

Clave secreta hardcodeada ("secret", "password123")
API deprecada que funciona pero tiene reemplazo moderno
Lógica de negocio incorrecta o incompleta
Código redundante o de baja legibilidad
Falta de validaciones en flujo de negocio
Patrones de diseño incorrectos pero funcionales
Concurrencia no segura
Configuración funcional pero no óptima

→ PRESERVAR tal cual. No corregir, no mejorar, no comentar.
PASO 4 — Procesamiento según tipo de archivo
Tipo A — Código fuente
Aplica únicamente las correcciones clasificadas como 🔴 ERROR DE COMPILACIÓN.
No alteres ningún elemento clasificado como 🟡 PROBLEMA FUNCIONAL O DE CALIDAD.
Si falta un archivo referenciado, créalo con la implementación mínima necesaria para compilar.
Tipo B — Configuración / documentación
Extrae el contenido tal cual, sin modificaciones salvo errores evidentes de sintaxis
(ej: YAML mal indentado).
Tipo C — Excel (.xlsx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un archivo Excel funcional con:

Fila de encabezados en negrita con color de fondo distintivo
Columnas con ancho ajustado al contenido
Tipos de dato correctos por columna
Validaciones si la descripción lo indica
Hojas nombradas descriptivamente si hay más de una
Filas de ejemplo si no hay datos reales

Tipo D — Word (.docx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un documento Word funcional con:

Estilos de título (Título 1, Título 2) para jerarquía de secciones
Fuente legible (Calibri o equivalente), tamaño 11-12pt para cuerpo
Márgenes estándar
Tabla de contenido si tiene múltiples secciones
Tablas con encabezados en negrita si aplica

Tipo E — Otro
Genera el archivo con el contenido o estructura más apropiada según la descripción.
PASO 5 — Entrega de archivos
Entregá cada archivo con su ruta completa, respetando exactamente la estructura de rutas
indicada por los marcadores: un bloque por archivo, precedido por su ruta. No generes ZIPs
ni archivos adjuntos.
La entrega debe incluir:

Archivos de código con únicamente los errores de compilación corregidos
Archivos de configuración y documentación sin cambios
Archivos nuevos creados para resolver dependencias de compilación faltantes
Archivos Excel y Word generados desde descripción

IMPORTANTE: Entregá los archivos completos al finalizar. No preguntes si el usuario
quiere recibirlos. Simplemente entregalos; No debes desplegar en el chat el resumen de lo que arreglaste, solo entregá los archivos.

REGLAS IMPORTANTES

No omitas ningún archivo aunque no tenga errores ni modificaciones
Respeta los nombres y rutas exactas indicadas por los marcadores
Si un archivo no tiene marcador claro, infiere el nombre desde su contenido
Si la cadena contiene solo documentación, placeholders o binarios fake, NO la reproduzcas:
aplicá PASO 0 (materializar el proyecto del briefing). Reproducir la carcasa es un fallo.
No agregues texto después del último archivo entregado
No preguntes si el usuario quiere los archivos: simplemente entregalos siempre
Si detectas que falta un archivo de configuración necesario para compilar
(pom.xml, package.json, requirements.txt, build.gradle, etc.), créalo e inclúyelo
inferiendo su contenido desde los imports y frameworks detectados en el código
Nunca corrijas problemas 🟡 aunque parezcan obvios o fáciles de mejorar.
El participante que recibirá este proyecto los debe encontrar y resolver él mismo.


INPUT
Aquí está la cadena con los archivos:

// === ARCHIVO: app/package.json ===
{
  "name": "order-management-api",
  "version": "1.0.0",
  "description": "API REST para gestión de órdenes sobre DynamoDB",
  "main": "dist/main.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/main.js",
    "dev": "ts-node src/main.ts",
    "test": "jest",
    "test:unit": "jest test/unit",
    "test:integration": "jest test/integration"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "aws-sdk": "^2.1691.0",
    "dotenv": "^16.4.5",
    "express": "^4.21.0",
    "uuid": "^9.0.1"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/jest": "^29.5.14",
    "@types/supertest": "^2.0.16",
    "@types/uuid": "^9.0.8",
    "jest": "^29.7.0",
    "supertest": "^7.0.0",
    "ts-jest": "^29.2.5",
    "ts-node": "^10.9.2",
    "typescript": "^5.7.2"
  },
  "jest": {
    "preset": "ts-jest",
    "testEnvironment": "node",
    "moduleFileExtensions": [
      "ts",
      "js"
    ],
    "transform": {
      "^.+\\.ts$": "ts-jest"
    },
    "testMatch": [
      "**/*.test.ts"
    ]
  }
}


// === ARCHIVO: app/tsconfig.json ===
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "**/*.test.ts"]
}

// === ARCHIVO: app/src/main.ts ===
import express from 'express';
import dotenv from 'dotenv';
import { OrderController } from './infrastructure/controllers/OrderController';
import { errorHandler } from './infrastructure/config/errorHandler';

// Cargar variables de entorno
dotenv.config();

// Configuración de Express
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Rutas
const orderController = new OrderController();
app.post('/orders', orderController.createOrder.bind(orderController));
app.get('/orders/:id', orderController.getOrder.bind(orderController));
app.put('/orders/:id', orderController.updateOrder.bind(orderController));
app.delete('/orders/:id', orderController.deleteOrder.bind(orderController));
app.get('/orders', orderController.listOrders.bind(orderController));

// Manejo global de errores
app.use(errorHandler);

// Iniciar servidor
app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});

// === ARCHIVO: app/src/domain/models/Order.ts ===
import { v4 as uuidv4 } from 'uuid';

export interface OrderDto {
    id?: string;
    cliente: string;
    producto: string;
    cantidad: number;
    precio: number;
    fecha?: Date;
}

export class Order {
    private readonly _id: string;
    private _cliente: string;
    private _producto: string;
    private _cantidad: number;
    private _precio: number;
    private readonly _fecha: Date;

    constructor(cliente: string, producto: string, cantidad: number, precio: number, id?: string) {
        this._id = id || uuidv4();
        this._cliente = cliente;
        this._producto = producto;
        this._cantidad = cantidad;
        this._precio = precio;
        this._fecha = new Date();
    }

    get id(): string {
        return this._id;
    }

    get cliente(): string {
        return this._cliente;
    }

    set cliente(value: string) {
        this._cliente = value;
    }

    get producto(): string {
        return this._producto;
    }

    set producto(value: string) {
        this._producto = value;
    }

    get cantidad(): number {
        return this._cantidad;
    }

    set cantidad(value: number) {
        this._cantidad = value;
    }

    get precio(): number {
        return this._precio;
    }

    set precio(value: number) {
        this._precio = value;
    }

    get fecha(): Date {
        return this._fecha;
    }

    toDto(): OrderDto {
        return {
            id: this._id,
            cliente: this._cliente,
            producto: this._producto,
            cantidad: this._cantidad,
            precio: this._precio,
            fecha: this._fecha
        };
    }

    static fromDto(dto: OrderDto): Order {
        return new Order(
            dto.cliente,
            dto.producto,
            dto.cantidad,
            dto.precio,
            dto.id
        );
    }
}

// === ARCHIVO: app/src/domain/repositories/OrderRepository.ts ===
import { Order, OrderDto } from '../models/Order';

export interface OrderRepository {
    create(order: Order): Promise<Order>;
    findById(id: string): Promise<Order | null>;
    update(id: string, order: Order): Promise<Order | null>;
    delete(id: string): Promise<boolean>;
    list(filters?: { cliente?: string; producto?: string }): Promise<Order[]>;
}

// === ARCHIVO: app/src/infrastructure/repositories/DynamoOrderRepository.ts ===
import { DynamoDB } from 'aws-sdk';
import { Order, OrderDto } from '../../domain/models/Order';
import { OrderRepository } from '../../domain/repositories/OrderRepository';
import dotenv from 'dotenv';

dotenv.config();

export class DynamoOrderRepository implements OrderRepository {
    private readonly dynamoDb: DynamoDB.DocumentClient;
    private readonly tableName: string;

    constructor() {
        this.dynamoDb = new DynamoDB.DocumentClient({
            region: process.env.AWS_REGION || 'us-east-1',
            endpoint: process.env.DYNAMODB_ENDPOINT
        });
        this.tableName = process.env.DYNAMODB_TABLE || 'Orders';
    }

    async create(order: Order): Promise<Order> {
        const params = {
            TableName: this.tableName,
            Item: {
                id: order.id,
                cliente: order.cliente,
                producto: order.producto,
                cantidad: order.cantidad,
                precio: order.precio,
                fecha: order.fecha.toISOString()
            }
        };

        await this.dynamoDb.put(params).promise();
        return order;
    }

    async findById(id: string): Promise<Order | null> {
        const params = {
            TableName: this.tableName,
            Key: { id }
        };

        const result = await this.dynamoDb.get(params).promise();
        if (!result.Item) {
            return null;
        }

        return new Order(
            result.Item.cliente,
            result.Item.producto,
            result.Item.cantidad,
            result.Item.precio,
            result.Item.id
        );
    }

    async update(id: string, order: Order): Promise<Order | null> {
        const params = {
            TableName: this.tableName,
            Key: { id },
            UpdateExpression: 'set cliente = :cliente, producto = :producto, cantidad = :cantidad, precio = :precio',
            ExpressionAttributeValues: {
                ':cliente': order.cliente,
                ':producto': order.producto,
                ':cantidad': order.cantidad,
                ':precio': order.precio
            },
            ReturnValues: 'ALL_NEW'
        };

        const result = await this.dynamoDb.update(params).promise();
        if (!result.Attributes) {
            return null;
        }

        return new Order(
            result.Attributes.cliente,
            result.Attributes.producto,
            result.Attributes.cantidad,
            result.Attributes.precio,
            result.Attributes.id
        );
    }

    async delete(id: string): Promise<boolean> {
        const params = {
            TableName: this.tableName,
            Key: { id }
        };

        await this.dynamoDb.delete(params).promise();
        return true;
    }

    async list(filters?: { cliente?: string; producto?: string }): Promise<Order[]> {
        let params: DynamoDB.DocumentClient.ScanInput = {
            TableName: this.tableName
        };

        if (filters?.cliente || filters?.producto) {
            params.FilterExpression = '';
            params.ExpressionAttributeValues = {};

            if (filters.cliente) {
                params.FilterExpression += 'cliente = :cliente';
                params.ExpressionAttributeValues[':cliente'] = filters.cliente;
            }

            if (filters.producto) {
                if (params.FilterExpression) {
                    params.FilterExpression += ' and ';
                }
                params.FilterExpression += 'producto = :producto';
                params.ExpressionAttributeValues[':producto'] = filters.producto;
            }
        }

        const result = await this.dynamoDb.scan(params).promise();
        if (!result.Items) {
            return [];
        }

        return result.Items.map(item =>
            new Order(
                item.cliente,
                item.producto,
                item.cantidad,
                item.precio,
                item.id
            )
        );
    }
}

// === ARCHIVO: app/src/application/services/OrderService.ts ===
import { Order, OrderDto } from '../../domain/models/Order';
import { OrderRepository } from '../../domain/repositories/OrderRepository';

export class OrderService {
    private readonly orderRepository: OrderRepository;

    constructor(orderRepository: OrderRepository) {
        this.orderRepository = orderRepository;
    }

    async createOrder(dto: OrderDto): Promise<OrderDto> {
        if (!dto.cliente || dto.cliente.trim().length === 0) {
            throw new Error('El cliente es requerido');
        }
        if (!dto.producto || dto.producto.trim().length === 0) {
            throw new Error('El producto es requerido');
        }
        if (!dto.cantidad || dto.cantidad <= 0) {
            throw new Error('La cantidad debe ser mayor a 0');
        }
        if (!dto.precio || dto.precio <= 0) {
            throw new Error('El precio debe ser mayor a 0');
        }

        const order = Order.fromDto(dto);
        const created = await this.orderRepository.create(order);
        return created.toDto();
    }

    async getOrder(id: string): Promise<OrderDto | null> {
        if (!id || id.trim().length === 0) {
            throw new Error('El ID de la orden es requerido');
        }

        const order = await this.orderRepository.findById(id);
        if (!order) {
            return null;
        }
        return order.toDto();
    }

    async updateOrder(id: string, dto: OrderDto): Promise<OrderDto | null> {
        if (!id || id.trim().length === 0) {
            throw new Error('El ID de la orden es requerido');
        }

        const existingOrder = await this.orderRepository.findById(id);
        if (!existingOrder) {
            return null;
        }

        if (dto.cliente !== undefined) {
            if (dto.cliente.trim().length === 0) {
                throw new Error('El cliente no puede estar vacio');
            }
            existingOrder.cliente = dto.cliente;
        }
        if (dto.producto !== undefined) {
            if (dto.producto.trim().length === 0) {
                throw new Error('El producto no puede estar vacio');
            }
            existingOrder.producto = dto.producto;
        }
        if (dto.cantidad !== undefined) {
            if (dto.cantidad <= 0) {
                throw new Error('La cantidad debe ser mayor a 0');
            }
            existingOrder.cantidad = dto.cantidad;
        }
        if (dto.precio !== undefined) {
            if (dto.precio <= 0) {
                throw new Error('El precio debe ser mayor a 0');
            }
            existingOrder.precio = dto.precio;
        }

        const updated = await this.orderRepository.update(id, existingOrder);
        return updated ? updated.toDto() : null;
    }

    async deleteOrder(id: string): Promise<boolean> {
        if (!id || id.trim().length === 0) {
            throw new Error('El ID de la orden es requerido');
        }

        const existingOrder = await this.orderRepository.findById(id);
        if (!existingOrder) {
            return false;
        }

        return await this.orderRepository.delete(id);
    }

    async listOrders(filters?: { cliente?: string; producto?: string }): Promise<OrderDto[]> {
        const orders = await this.orderRepository.list(filters);
        return orders.map(order => order.toDto());
    }
}

// === ARCHIVO: app/src/infrastructure/controllers/OrderController.ts ===
import { Request, Response, NextFunction, Router } from 'express';
import { OrderDto } from '../../domain/models/Order';
import { OrderService } from '../../application/services/OrderService';

const router = Router();

export class OrderController {
  private readonly orderService: OrderService;

  constructor(orderService: OrderService) {
    this.orderService = orderService;
    this.registerRoutes();
  }

  private registerRoutes(): void {
    router.get('/orders', this.listOrders.bind(this));
    router.get('/orders/:id', this.getOrder.bind(this));
    router.post('/orders', this.createOrder.bind(this));
    router.put('/orders/:id', this.updateOrder.bind(this));
    router.delete('/orders/:id', this.deleteOrder.bind(this));
  }

  getRouter(): Router {
    return router;
  }

  async listOrders(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { cliente, producto } = req.query;
      const filters: { cliente?: string; producto?: string } = {};
      
      if (cliente && typeof cliente === 'string') {
        filters.cliente = cliente;
      }
      if (producto && typeof producto === 'string') {
        filters.producto = producto;
      }

      const orders = await this.orderService.list(filters);
      const ordersDto: OrderDto[] = orders.map(order => order.toDto());
      
      res.status(200).json(ordersDto);
    } catch (error) {
      next(error);
    }
  }

  async getOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      
      if (!id || id.trim() === '') {
        res.status(400).json({ error: 'El ID de la orden es requerido' });
        return;
      }

      const order = await this.orderService.findById(id);
      
      if (!order) {
        res.status(404).json({ error: `Orden con ID ${id} no encontrada` });
        return;
      }

      res.status(200).json(order.toDto());
    } catch (error) {
      next(error);
    }
  }

  async createOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { cliente, producto, cantidad, precio } = req.body;

      if (!cliente || typeof cliente !== 'string' || cliente.trim() === '') {
        res.status(400).json({ error: 'El campo cliente es requerido y debe ser una cadena no vacía' });
        return;
      }

      if (!producto || typeof producto !== 'string' || producto.trim() === '') {
        res.status(400).json({ error: 'El campo producto es requerido y debe ser una cadena no vacía' });
        return;
      }

      if (cantidad === undefined || typeof cantidad !== 'number' || cantidad <= 0) {
        res.status(400).json({ error: 'El campo cantidad es requerido y debe ser un número mayor a 0' });
        return;
      }

      if (precio === undefined || typeof precio !== 'number' || precio <= 0) {
        res.status(400).json({ error: 'El campo precio es requerido y debe ser un número mayor a 0' });
        return;
      }

      const orderDto: OrderDto = {
        cliente: cliente.trim(),
        producto: producto.trim(),
        cantidad,
        precio
      };

      const createdOrder = await this.orderService.create(orderDto);
      res.status(201).json(createdOrder.toDto());
    } catch (error) {
      next(error);
    }
  }

  async updateOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      const { cliente, producto, cantidad, precio } = req.body;

      if (!id || id.trim() === '') {
        res.status(400).json({ error: 'El ID de la orden es requerido' });
        return;
      }

      const existingOrder = await this.orderService.findById(id);
      if (!existingOrder) {
        res.status(404).json({ error: `Orden con ID ${id} no encontrada` });
        return;
      }

      const updateData: Partial<OrderDto> = {};
      
      if (cliente !== undefined) {
        if (typeof cliente !== 'string' || cliente.trim() === '') {
          res.status(400).json({ error: 'El campo cliente debe ser una cadena no vacía' });
          return;
        }
        updateData.cliente = cliente.trim();
      }

      if (producto !== undefined) {
        if (typeof producto !== 'string' || producto.trim() === '') {
          res.status(400).json({ error: 'El campo producto debe ser una cadena no vacía' });
          return;
        }
        updateData.producto = producto.trim();
      }

      if (cantidad !== undefined) {
        if (typeof cantidad !== 'number' || cantidad <= 0) {
          res.status(400).json({ error: 'El campo cantidad debe ser un número mayor a 0' });
          return;
        }
        updateData.cantidad = cantidad;
      }

      if (precio !== undefined) {
        if (typeof precio !== 'number' || precio <= 0) {
          res.status(400).json({ error: 'El campo precio debe ser un número mayor a 0' });
          return;
        }
        updateData.precio = precio;
      }

      const updatedOrder = await this.orderService.update(id, updateData);
      
      if (!updatedOrder) {
        res.status(404).json({ error: `Orden con ID ${id} no encontrada` });
        return;
      }

      res.status(200).json(updatedOrder.toDto());
    } catch (error) {
      next(error);
    }
  }

  async deleteOrder(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { id } = req.params;
      
      if (!id || id.trim() === '') {
        res.status(400).json({ error: 'El ID de la orden es requerido' });
        return;
      }

      const deleted = await this.orderService.delete(id);
      
      if (!deleted) {
        res.status(404).json({ error: `Orden con ID ${id} no encontrada` });
        return;
      }

      res.status(204).send();
    } catch (error) {
      next(error);
    }
  }
}

// === ARCHIVO: app/src/infrastructure/config/aws.ts ===
import AWS from 'aws-sdk';
import * as dotenv from 'dotenv';

dotenv.config();

export interface AwsConfig {
  region: string;
  endpoint?: string;
  accessKeyId?: string;
  secretAccessKey?: string;
}

export class AwsClientFactory {
  private static instance: AWS.DynamoDB.DocumentClient | null = null;

  static getDynamoDbClient(): AWS.DynamoDB.DocumentClient {
    if (AwsClientFactory.instance) {
      return AwsClientFactory.instance;
    }

    const config = AwsClientFactory.loadConfig();
    
    const awsConfig: AWS.DynamoDB.DocumentClientConfig = {
      region: config.region,
    };

    if (config.endpoint) {
      awsConfig.endpoint = config.endpoint;
    }

    if (config.accessKeyId && config.secretAccessKey) {
      awsConfig.credentials = {
        accessKeyId: config.accessKeyId,
        secretAccessKey: config.secretAccessKey,
      };
    }

    AwsClientFactory.instance = new AWS.DynamoDB.DocumentClient(awsConfig);
    return AwsClientFactory.instance;
  }

  private static loadConfig(): AwsConfig {
    const region = process.env.AWS_REGION || 'us-east-1';
    const endpoint = process.env.DYNAMODB_ENDPOINT;
    const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
    const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;

    if (!region) {
      console.warn('AWS_REGION no está definida, usando us-east-1 por defecto');
    }

    if (!accessKeyId || !secretAccessKey) {
      console.warn('Credenciales de AWS no proporcionadas. Usando credenciales del entorno de ejecución.');
    }

    return {
      region,
      endpoint,
      accessKeyId,
      secretAccessKey,
    };
  }

  static getTableName(): string {
    const tableName = process.env.DYNAMODB_TABLE_NAME;
    if (!tableName) {
      throw new Error('DYNAMODB_TABLE_NAME no está definido en las variables de entorno');
    }
    return tableName;
  }

  static resetInstance(): void {
    AwsClientFactory.instance = null;
  }
}

export function createDynamoDbClient(): AWS.DynamoDB.DocumentClient {
  return AwsClientFactory.getDynamoDbClient();
}

export function getDynamoTableName(): string {
  return AwsClientFactory.getTableName();
}

// === ARCHIVO: app/src/infrastructure/config/errorHandler.ts ===
import { Request, Response, NextFunction, ErrorRequestHandler } from 'express';

export interface AppError extends Error {
  statusCode?: number;
  isOperational?: boolean;
}

export class ValidationError extends Error implements AppError {
  statusCode: number;
  isOperational: boolean;

  constructor(message: string) {
    super(message);
    this.name = 'ValidationError';
    this.statusCode = 400;
    this.isOperational = true;
    Error.captureStackTrace(this, this.constructor);
  }
}

export class NotFoundError extends Error implements AppError {
  statusCode: number;
  isOperational: boolean;

  constructor(message: string) {
    super(message);
    this.name = 'NotFoundError';
    this.statusCode = 404;
    this.isOperational = true;
    Error.captureStackTrace(this, this.constructor);
  }
}

export class DatabaseError extends Error implements AppError {
  statusCode: number;
  isOperational: boolean;

  constructor(message: string, public readonly originalError?: Error) {
    super(message);
    this.name = 'DatabaseError';
    this.statusCode = 500;
    this.isOperational = false;
    Error.captureStackTrace(this, this.constructor);
  }
}

export const errorHandler: ErrorRequestHandler = (
  err: AppError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  console.error('Error capturado por el middleware global:', {
    name: err.name,
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString(),
  });

  if (res.headersSent) {
    return next(err);
  }

  const statusCode = err.statusCode || 500;
  const message = err.isOperational 
    ? err.message 
    : 'Error interno del servidor. Por favor, contacte al administrador.';

  const errorResponse: Record<string, unknown> = {
    error: {
      name: err.name,
      message: message,
      statusCode: statusCode,
      timestamp: new Date().toISOString(),
      path: req.path,
    },
  };

  if (process.env.NODE_ENV === 'development' && err.stack) {
    (errorResponse as Record<string, unknown>).stack = err.stack;
  }

  res.status(statusCode).json(errorResponse);
};

export const notFoundHandler = (req: Request, res: Response): void => {
  console.warn('Ruta no encontrada:', {
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString(),
  });

  res.status(404).json({
    error: {
      name: 'NotFoundError',
      message: `La ruta ${req.method} ${req.path} no existe`,
      statusCode: 404,
      timestamp: new Date().toISOString(),
      path: req.path,
    },
  });
};

export const requestLogger = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log('Petición procesada:', {
      method: req.method,
      path: req.path,
      query: req.query,
      statusCode: res.statusCode,
      duration: `${duration}ms`,
      timestamp: new Date().toISOString(),
    });
  });

  next();
};

// === ARCHIVO: app/test/unit/OrderService.test.ts ===
import { OrderService } from '../../src/application/services/OrderService';
import { OrderRepository } from '../../src/domain/repositories/OrderRepository';
import { Order, OrderDto } from '../../src/domain/models/Order';

describe('OrderService', () => {
  let orderService: OrderService;
  let mockOrderRepository: jest.Mocked<OrderRepository>;

  beforeEach(() => {
    mockOrderRepository = {
      create: jest.fn(),
      findById: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      list: jest.fn(),
    } as jest.Mocked<OrderRepository>;
    orderService = new OrderService(mockOrderRepository);
  });

  describe('createOrder', () => {
    it('should create an order successfully', async () => {
      const orderDto: OrderDto = {
        id: '123',
        cliente: 'Test Client',
        producto: 'Test Product',
        cantidad: 5,
        precio: 100.0,
        fecha: new Date(),
      };
      const order = Order.fromDto(orderDto);
      mockOrderRepository.create.mockResolvedValue(order);

      const result = await orderService.createOrder(orderDto);

      expect(mockOrderRepository.create).toHaveBeenCalled();
      expect(result).toEqual(orderDto);
    });

    it('should throw error when repository fails', async () => {
      const orderDto: OrderDto = {
        id: '123',
        cliente: 'Test Client',
        producto: 'Test Product',
        cantidad: 5,
        precio: 100.0,
        fecha: new Date(),
      };
      mockOrderRepository.create.mockRejectedValue(new Error('DB Error'));

      await expect(orderService.createOrder(orderDto)).rejects.toThrow('DB Error');
    });
  });

  describe('getOrder', () => {
    it('should return order when found', async () => {
      const orderDto: OrderDto = {
        id: '123',
        cliente: 'Test Client',
        producto: 'Test Product',
        cantidad: 5,
        precio: 100.0,
        fecha: new Date(),
      };
      const order = Order.fromDto(orderDto);
      mockOrderRepository.findById.mockResolvedValue(order);

      const result = await orderService.getOrder('123');

      expect(mockOrderRepository.findById).toHaveBeenCalledWith('123');
      expect(result).toEqual(orderDto);
    });

    it('should return null when order not found', async () => {
      mockOrderRepository.findById.mockResolvedValue(null);

      const result = await orderService.getOrder('999');

      expect(mockOrderRepository.findById).toHaveBeenCalledWith('999');
      expect(result).toBeNull();
    });
  });

  describe('updateOrder', () => {
    it('should update order successfully', async () => {
      const orderDto: OrderDto = {
        id: '123',
        cliente: 'Updated Client',
        producto: 'Updated Product',
        cantidad: 10,
        precio: 200.0,
        fecha: new Date(),
      };
      const order = Order.fromDto(orderDto);
      mockOrderRepository.update.mockResolvedValue(order);

      const result = await orderService.updateOrder('123', orderDto);

      expect(mockOrderRepository.update).toHaveBeenCalledWith('123', expect.any(Order));
      expect(result).toEqual(orderDto);
    });

    it('should return null when order not found', async () => {
      const orderDto: OrderDto = {
        id: '999',
        cliente: 'Updated Client',
        producto: 'Updated Product',
        cantidad: 10,
        precio: 200.0,
        fecha: new Date(),
      };
      mockOrderRepository.update.mockResolvedValue(null);

      const result = await orderService.updateOrder('999', orderDto);

      expect(result).toBeNull();
    });
  });

  describe('deleteOrder', () => {
    it('should delete order successfully', async () => {
      mockOrderRepository.delete.mockResolvedValue(true);

      const result = await orderService.deleteOrder('123');

      expect(mockOrderRepository.delete).toHaveBeenCalledWith('123');
      expect(result).toBe(true);
    });

    it('should return false when order not found', async () => {
      mockOrderRepository.delete.mockResolvedValue(false);

      const result = await orderService.deleteOrder('999');

      expect(result).toBe(false);
    });
  });

  describe('listOrders', () => {
    it('should return all orders when no filters', async () => {
      const orders: OrderDto[] = [
        { id: '1', cliente: 'Client 1', producto: 'Product 1', cantidad: 1, precio: 10.0, fecha: new Date() },
        { id: '2', cliente: 'Client 2', producto: 'Product 2', cantidad: 2, precio: 20.0, fecha: new Date() },
      ];
      const domainOrders = orders.map(o => Order.fromDto(o));
      mockOrderRepository.list.mockResolvedValue(domainOrders);

      const result = await orderService.listOrders();

      expect(mockOrderRepository.list).toHaveBeenCalledWith(undefined);
      expect(result).toEqual(orders);
    });

    it('should filter orders by cliente', async () => {
      const orders: OrderDto[] = [
        { id: '1', cliente: 'Client 1', producto: 'Product 1', cantidad: 1, precio: 10.0, fecha: new Date() },
      ];
      const domainOrders = orders.map(o => Order.fromDto(o));
      mockOrderRepository.list.mockResolvedValue(domainOrders);

      const result = await orderService.listOrders({ cliente: 'Client 1' });

      expect(mockOrderRepository.list).toHaveBeenCalledWith({ cliente: 'Client 1' });
      expect(result).toEqual(orders);
    });

    it('should filter orders by producto', async () => {
      const orders: OrderDto[] = [
        { id: '1', cliente: 'Client 1', producto: 'Product 1', cantidad: 1, precio: 10.0, fecha: new Date() },
      ];
      const domainOrders = orders.map(o => Order.fromDto(o));
      mockOrderRepository.list.mockResolvedValue(domainOrders);

      const result = await orderService.listOrders({ producto: 'Product 1' });

      expect(mockOrderRepository.list).toHaveBeenCalledWith({ producto: 'Product 1' });
      expect(result).toEqual(orders);
    });
  });
});

// === ARCHIVO: app/test/integration/OrderController.test.ts ===
import request from 'supertest';
import { Express } from 'express';
import { OrderController } from '../../src/infrastructure/controllers/OrderController';
import { OrderService } from '../../src/application/services/OrderService';
import { OrderDto } from '../../src/domain/models/Order';

describe('OrderController Integration Tests', () => {
  let app: Express;
  let orderService: OrderService;
  let controller: OrderController;

  beforeAll(() => {
    orderService = new OrderService({} as any);
    controller = new OrderController(orderService);
    app = require('../../src/main').default;
  });

  describe('POST /orders', () => {
    it('should create a new order', async () => {
      const newOrder: OrderDto = {
        id: 'ord-123',
        cliente: 'Test Client',
        producto: 'Test Product',
        cantidad: 5,
        precio: 100.0,
        fecha: new Date(),
      };

      const response = await request(app)
        .post('/orders')
        .send(newOrder)
        .expect(201);

      expect(response.body).toHaveProperty('id');
      expect(response.body.cliente).toBe(newOrder.cliente);
    });

    it('should return 400 for invalid order data', async () => {
      const invalidOrder = {
        cliente: 'Test Client',
        producto: 'Test Product',
      };

      const response = await request(app)
        .post('/orders')
        .send(invalidOrder)
        .expect(400);

      expect(response.body).toHaveProperty('error');
    });
  });

  describe('GET /orders/:id', () => {
    it('should return order by id', async () => {
      const response = await request(app)
        .get('/orders/ord-123')
        .expect(200);

      expect(response.body).toHaveProperty('id');
    });

    it('should return 404 for non-existent order', async () => {
      const response = await request(app)
        .get('/orders/non-existent-id')
        .expect(404);

      expect(response.body).toHaveProperty('error');
    });
  });

  describe('PUT /orders/:id', () => {
    it('should update existing order', async () => {
      const updatedOrder: OrderDto = {
        id: 'ord-123',
        cliente: 'Updated Client',
        producto: 'Updated Product',
        cantidad: 10,
        precio: 200.0,
        fecha: new Date(),
      };

      const response = await request(app)
        .put('/orders/ord-123')
        .send(updatedOrder)
        .expect(200);

      expect(response.body.cliente).toBe('Updated Client');
    });

    it('should return 404 when updating non-existent order', async () => {
      const updatedOrder: OrderDto = {
        id: 'non-existent',
        cliente: 'Updated Client',
        producto: 'Updated Product',
        cantidad: 10,
        precio: 200.0,
        fecha: new Date(),
      };

      const response = await request(app)
        .put('/orders/non-existent')
        .send(updatedOrder)
        .expect(404);
    });
  });

  describe('DELETE /orders/:id', () => {
    it('should delete existing order', async () => {
      const response = await request(app)
        .delete('/orders/ord-123')
        .expect(204);

      expect(response.body).toEqual({});
    });

    it('should return 404 when deleting non-existent order', async () => {
      const response = await request(app)
        .delete('/orders/non-existent')
        .expect(404);

      expect(response.body).toHaveProperty('error');
    });
  });

  describe('GET /orders', () => {
    it('should return all orders without filters', async () => {
      const response = await request(app)
        .get('/orders')
        .expect(200);

      expect(Array.isArray(response.body)).toBe(true);
    });

    it('should filter orders by cliente', async () => {
      const response = await request(app)
        .get('/orders')
        .query({ cliente: 'Test Client' })
        .expect(200);

      expect(Array.isArray(response.body)).toBe(true);
    });

    it('should filter orders by producto', async () => {
      const response = await request(app)
        .get('/orders')
        .query({ producto: 'Test Product' })
        .expect(200);

      expect(Array.isArray(response.body)).toBe(true);
    });
  });
});

// === ARCHIVO: app/README.md ===
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

// === ARCHIVO: infra/providers.tf ===
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

// === ARCHIVO: infra/variables.tf ===
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

// === ARCHIVO: infra/modules/dynamodb/variables.tf ===
# Variables para el módulo DynamoDB
# Este archivo define las variables necesarias para configurar
# una tabla DynamoDB con sus atributos y GSIs.

variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "billing_mode" {
  description = "Modo de facturación para la tabla DynamoDB (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Clave hash (partition key) para la tabla DynamoDB"
  type        = string
}

variable "hash_key_type" {
  description = "Tipo de dato de la clave hash (S para string, N para number)"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Clave de rango (sort key) para la tabla DynamoDB"
  type        = string
  default     = null
}

variable "range_key_type" {
  description = "Tipo de dato de la clave de rango (S para string, N para number)"
  type        = string
  default     = "S"
}

variable "attributes" {
  description = "Lista de atributos para la tabla DynamoDB"
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "gsi" {
  description = "Lista de GSI para la tabla DynamoDB"
  type = list(object({
    name            = string
    hash_key       = string
    hash_key_type  = string
    range_key      = string
    range_key_type = string
    projection_type = string
  }))
  default = []
}

variable "tags" {
  description = "Tags para la tabla DynamoDB"
  type        = map(string)
  default     = {}
}

variable "ttl_attribute" {
  description = "Atributo para TTL (Time To Live) en la tabla DynamoDB"
  type        = string
  default     = null
}

variable "stream_enabled" {
  description = "Habilita el stream para la tabla DynamoDB"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Tipo de vista para el stream (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = null
}

// === ARCHIVO: infra/versions.tf ===
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

// === ARCHIVO: infra/main.tf ===
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

// === ARCHIVO: infra/outputs.tf ===
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

// === ARCHIVO: infra/README.md ===
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

// === ARCHIVO: infra/environments/dev/terraform.tfvars ===
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

// === ARCHIVO: infra/modules/dynamodb/main.tf ===
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

// === ARCHIVO: infra/modules/dynamodb/outputs.tf ===
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

// === ARCHIVO: docker-compose.yml ===
# Infraestructura local del reto. SOLO desarrollo: credenciales de ejemplo (local-dev-only), puertos en loopback.
# Levantar: docker compose up -d --wait
name: infra-local
services:
  dynamodb-local:
    image: "amazon/dynamodb-local:2.5.2"
    command: ["-jar","DynamoDBLocal.jar","-sharedDb","-inMemory"]
    ports:
      - "127.0.0.1:8000:8000"
    healthcheck:
      test: ["CMD-SHELL","bash -c ':> /dev/tcp/127.0.0.1/8000' || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 5s


// === ARCHIVO: infra-local/README.md ===
# Infraestructura local

Servicios de soporte para el reto, definidos en `docker-compose.yml` (raiz del repo).

```bash
docker compose up -d --wait
```

| Servicio | Imagen | Puertos (host) |
|---|---|---|
| DynamoDB Local | `amazon/dynamodb-local:2.5.2` | 8000 |

Credenciales: solo de desarrollo local (`local-dev-only`, `local`). No son secretos ni deben reutilizarse.
Los scripts de `infra-local/` (tablas, topics) se ejecutan con el compose en estado healthy.


// === ARCHIVO: infra-local/dynamodb/create-tables.sh ===
#!/usr/bin/env bash
# Crea las tablas en DynamoDB Local (idempotente). Credenciales dummy: DynamoDB Local no valida firmas.
set -euo pipefail

export AWS_ACCESS_KEY_ID=local
export AWS_SECRET_ACCESS_KEY=local
export AWS_REGION=us-east-1
ENDPOINT="${DYNAMODB_ENDPOINT:-http://localhost:8000}"

create_table() {
  local name="$1" pk="$2" sk="${3:-}"
  if aws dynamodb describe-table --table-name "$name" --endpoint-url "$ENDPOINT" >/dev/null 2>&1; then
    echo "Tabla $name ya existe"
    return
  fi
  local attrs="AttributeName=$pk,AttributeType=S"
  local keys="AttributeName=$pk,KeyType=HASH"
  if [ -n "$sk" ]; then
    attrs="$attrs AttributeName=$sk,AttributeType=S"
    keys="$keys AttributeName=$sk,KeyType=RANGE"
  fi
  # shellcheck disable=SC2086
  aws dynamodb create-table --table-name "$name" --attribute-definitions $attrs --key-schema $keys \
    --billing-mode PAY_PER_REQUEST --endpoint-url "$ENDPOINT" >/dev/null
  echo "Tabla $name creada"
}

create_table "app-items" "id"

```
