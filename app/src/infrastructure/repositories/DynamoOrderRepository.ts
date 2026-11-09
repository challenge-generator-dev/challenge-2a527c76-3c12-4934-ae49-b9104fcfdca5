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