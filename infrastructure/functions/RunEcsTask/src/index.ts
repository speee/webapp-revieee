import { Callback, Context } from "aws-lambda";
import { createConnection, Connection } from "typeorm";
import "reflect-metadata";
import { ApiGatewayEvent } from "./ApiGatewayEvent";
import { RevieeeTarget } from "./entity/RevieeeTarget";
import { Task } from "./entity/Task";
import { TaskDefinition } from "./entity/TaskDefinition";

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

async function buildRevieeeTarget(connection: Connection, event: ApiGatewayEvent): Promise<RevieeeTarget> {
    const taskRepository = connection.getRepository(Task)
    const taskDefinitionRepository = connection.getRepository(TaskDefinition);
    const revieeeTarget = new RevieeeTarget(taskRepository, taskDefinitionRepository);
    revieeeTarget.repository = event.headRepository
    revieeeTarget.branch = event.headBranch;
    revieeeTarget.prNumber = event.prNumber;
    return revieeeTarget;
}

export function handler(event: ApiGatewayEvent, context: Context, callback: Callback) {
    (async () => {
        const connection = await buildConnection();
        const revieeeTarget = await buildRevieeeTarget(connection, event);
        return await revieeeTarget.create();
    })().then((task: Task) => {
        callback(null, task);
    }).catch((err: any) => {
        callback(err);
    });
}
