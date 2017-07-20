import { Callback, Context } from "aws-lambda";
import { createConnection, Connection } from "typeorm";
import "reflect-metadata";
import { ApiGatewayEvent } from "./ApiGatewayEvent";

async function buildConnection(): Promise<Connection> {
    return createConnection({
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
    });
}


export function handler(event: ApiGatewayEvent, context: Context, callback: Callback) {
    (async () => {
        const connection = await buildConnection();
    })();
}
