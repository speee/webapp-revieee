import { Callback, Context } from "aws-lambda";
import { Connection } from "typeorm";
import { Database } from "./Database";
import { WebhookEvent } from "./WebhookEvent";
import { RevieeeTarget } from "./entity/RevieeeTarget";
import { Task } from "./entity/Task";
import { TaskDefinition } from "./entity/TaskDefinition";

async function buildRevieeeTarget(connection: Connection, event: WebhookEvent): Promise<RevieeeTarget> {
    const taskRepository = connection.getRepository(Task);
    const taskDefinitionRepository = connection.getRepository(TaskDefinition);
    const revieeeTarget = new RevieeeTarget(taskRepository, taskDefinitionRepository);
    revieeeTarget.repository = event.headRepository;
    revieeeTarget.branch = event.headBranch;
    revieeeTarget.prNumber = event.prNumber;
    return revieeeTarget;
}

export function handler(event: WebhookEvent, context: Context, callback: Callback) {
    (async () => {
        const connection = await Database.createConnection();
        const revieeeTarget = await buildRevieeeTarget(connection, event);
        return await revieeeTarget.create();
    })().then((task: Task) => {
        callback(null, task);
    }).catch((err: any) => {
        callback(err);
    });
}
