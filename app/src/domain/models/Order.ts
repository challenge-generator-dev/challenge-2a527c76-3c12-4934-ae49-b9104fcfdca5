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