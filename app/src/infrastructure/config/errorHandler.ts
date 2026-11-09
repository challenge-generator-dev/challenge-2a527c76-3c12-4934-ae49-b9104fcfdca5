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