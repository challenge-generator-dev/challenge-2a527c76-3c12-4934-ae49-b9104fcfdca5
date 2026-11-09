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