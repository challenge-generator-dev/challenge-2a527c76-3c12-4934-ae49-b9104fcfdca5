# Implementación de CRUD de ordenes en DynamoDB

El sistema de gestión de órdenes en nuestra plataforma fintech requiere la implementación de operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre una tabla DynamoDB. Estas operaciones deben estar expuestas a través de una API REST. El objetivo es persistir y consultar órdenes de manera eficiente y segura.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | CRUD de ordenes sobre DynamoDB |
| **Nivel** | advanced-l2 |
| **Tipo** | practical |
| **Tiempo estimado** | 8 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y entregará cada archivo con su ruta.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Node.js 18+, npm, VS Code o similar.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y entregará cada archivo con su ruta. Guárdalos en la carpeta donde quieras trabajar, respetando las rutas.
- Ejecuta `npm install && npm run build` (o `npm start`). Si no hay errores, estás listo.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no entrega todos los archivos al terminar el análisis, escríbele: "entrégame todos los archivos con su ruta".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Configuración del entorno y creación de la tabla DynamoDB

**Objetivo:** Configurar el entorno de desarrollo y crear la tabla DynamoDB necesaria para almacenar las órdenes.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Configura tu entorno de desarrollo para trabajar con DynamoDB.
- Crea una tabla DynamoDB con las columnas necesarias para almacenar las órdenes (ID, cliente, producto, cantidad, precio, fecha).

**Entregable:** Tabla DynamoDB creada y configurada con las columnas necesarias.

<details>
<summary>Pistas de conocimiento</summary>

- Utiliza Terraform para gestionar la infraestructura como código.
- Define los atributos necesarios para la tabla DynamoDB.

</details>

### Fase 2: Implementación de la API REST para operaciones CRUD

**Objetivo:** Implementar la API REST que expone las operaciones CRUD sobre la tabla DynamoDB.

**Tiempo estimado:** 4 horas

**Instrucciones:**

- Implementa las rutas y controladores necesarios para las operaciones CRUD (Crear, Leer, Actualizar, Eliminar) en la API REST.
- Asegura que las operaciones CRUD interactúen correctamente con la tabla DynamoDB.

**Entregable:** API REST implementada con rutas y controladores para operaciones CRUD sobre la tabla DynamoDB.

<details>
<summary>Pistas de conocimiento</summary>

- Utiliza el marco de trabajo del lenguaje principal para implementar la API REST.
- Maneja los errores y validaciones necesarias para cada operación CRUD.

</details>

### Fase 3: Pruebas y optimización de la API REST

**Objetivo:** Realizar pruebas unitarias y de integración para asegurar la funcionalidad y optimizar el rendimiento de la API REST.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Escribe pruebas unitarias y de integración para las operaciones CRUD de la API REST.
- Optimiza el rendimiento de la API REST identificando y resolviendo cuellos de botella.

**Entregable:** Pruebas unitarias y de integración escritas y ejecutadas, API REST optimizada.

<details>
<summary>Pistas de conocimiento</summary>

- Utiliza las herramientas de trabajo del candidato para depurar y probar la API REST.
- Identifica y resuelve los cuellos de botella en el rendimiento de la API REST.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es una operación CRUD y cómo se implementa en una API REST?
- **paraQueSirve**: ¿Para qué sirve la tabla DynamoDB en este sistema de gestión de órdenes?
- **comoSeUsa**: ¿Cómo se usa Terraform para gestionar la infraestructura como código?
- **erroresComunes**: ¿Cuáles son los errores comunes al implementar operaciones CRUD en una API REST y cómo se manejan?
- **queDecisionesImplica**: ¿Qué decisiones implica la optimización del rendimiento de la API REST y cómo se toman?

## Criterios de Evaluacion

- Configuración correcta del entorno de desarrollo y creación de la tabla DynamoDB.
- Implementación correcta de la API REST con rutas y controladores para operaciones CRUD.
- Escrituras y ejecuciones de pruebas unitarias y de integración para las operaciones CRUD.
- Optimización del rendimiento de la API REST identificando y resolviendo cuellos de botella.

## Como trabajar con un asistente de IA

Hay dos caminos, elegi uno:

- **AGENTS.md** (recomendado) — instrucciones nativas del repo. Abri esta carpeta con tu agente local (Claude Code, Cursor, Codex, Copilot, Gemini) y las carga solo. Sabe que archivos faltan y con que comando se verifica, y completa el scaffold escribiendo en disco.
- **PROMPT_MEJORA.md** — para copiar y pegar en un chat (claude.ai, ChatGPT) si no tenes un agente en el IDE. Declara lo mismo que AGENTS.md; los archivos que te devuelva el chat los guardas en esta carpeta respetando las rutas.

Ninguno de los dos resuelve las fases del reto: eso es tu trabajo.

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

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
(cd app && npm install && npm run build) && (cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate) && docker compose config -q
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
