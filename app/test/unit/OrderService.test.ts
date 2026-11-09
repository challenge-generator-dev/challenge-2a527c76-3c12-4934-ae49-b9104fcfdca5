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