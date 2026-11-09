import { Order, OrderDto } from '../models/Order';

export interface OrderRepository {
    create(order: Order): Promise<Order>;
    findById(id: string): Promise<Order | null>;
    update(id: string, order: Order): Promise<Order | null>;
    delete(id: string): Promise<boolean>;
    list(filters?: { cliente?: string; producto?: string }): Promise<Order[]>;
}