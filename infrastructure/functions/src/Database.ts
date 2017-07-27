import "reflect-metadata";
import { createConnection, Connection, ConnectionOptions } from "typeorm";

export class Database {
    config: ConnectionOptions;

    constructor() {
        this.config = {
            "driver": {
                "type": "mysql",
                "host": process.env.TYPEORM_HOST,
                "port": process.env.TYPEORM_PORT,
                "username": process.env.TYPEORM_USERNAME,
                "password": process.env.TYPEORM_PASSWORD,
                "database": process.env.TYPEORM_DATABASE,
            },
            "entities": [
                __dirname + "/entity/*.js"
            ]
        };
    }

    async createConnection(): Promise<Connection> {
        return createConnection(this.config);
    }

    static async createConnection(): Promise<Connection> {
        return new Database().createConnection();
    }
}
