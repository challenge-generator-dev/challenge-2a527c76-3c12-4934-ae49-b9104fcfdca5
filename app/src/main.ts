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