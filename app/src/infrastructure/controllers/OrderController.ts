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