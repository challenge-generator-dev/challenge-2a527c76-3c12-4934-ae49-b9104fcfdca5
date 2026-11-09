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