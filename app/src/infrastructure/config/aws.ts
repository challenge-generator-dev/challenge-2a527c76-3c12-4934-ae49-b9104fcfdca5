import AWS from 'aws-sdk';
import * as dotenv from 'dotenv';

dotenv.config();

export interface AwsConfig {
  region: string;
  endpoint?: string;
  accessKeyId?: string;
  secretAccessKey?: string;
}

export class AwsClientFactory {
  private static instance: AWS.DynamoDB.DocumentClient | null = null;

  static getDynamoDbClient(): AWS.DynamoDB.DocumentClient {
    if (AwsClientFactory.instance) {
      return AwsClientFactory.instance;
    }

    const config = AwsClientFactory.loadConfig();
    
    const awsConfig: AWS.DynamoDB.DocumentClientConfig = {
      region: config.region,
    };

    if (config.endpoint) {
      awsConfig.endpoint = config.endpoint;
    }

    if (config.accessKeyId && config.secretAccessKey) {
      awsConfig.credentials = {
        accessKeyId: config.accessKeyId,
        secretAccessKey: config.secretAccessKey,
      };
    }

    AwsClientFactory.instance = new AWS.DynamoDB.DocumentClient(awsConfig);
    return AwsClientFactory.instance;
  }

  private static loadConfig(): AwsConfig {
    const region = process.env.AWS_REGION || 'us-east-1';
    const endpoint = process.env.DYNAMODB_ENDPOINT;
    const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
    const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;

    if (!region) {
      console.warn('AWS_REGION no está definida, usando us-east-1 por defecto');
    }

    if (!accessKeyId || !secretAccessKey) {
      console.warn('Credenciales de AWS no proporcionadas. Usando credenciales del entorno de ejecución.');
    }

    return {
      region,
      endpoint,
      accessKeyId,
      secretAccessKey,
    };
  }

  static getTableName(): string {
    const tableName = process.env.DYNAMODB_TABLE_NAME;
    if (!tableName) {
      throw new Error('DYNAMODB_TABLE_NAME no está definido en las variables de entorno');
    }
    return tableName;
  }

  static resetInstance(): void {
    AwsClientFactory.instance = null;
  }
}

export function createDynamoDbClient(): AWS.DynamoDB.DocumentClient {
  return AwsClientFactory.getDynamoDbClient();
}

export function getDynamoTableName(): string {
  return AwsClientFactory.getTableName();
}