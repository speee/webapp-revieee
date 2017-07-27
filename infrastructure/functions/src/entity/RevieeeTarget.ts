import { ECS } from "aws-sdk";
import { Repository } from "typeorm";
import { Task } from "./Task";
import { TaskDefinition } from "./TaskDefinition";
import { TaskDefinitionLoader } from "../TaskDefinitionLoader";

export class RevieeeTarget {
    repository: string;
    branch: string;
    prNumber: number;
    private taskDefinition: TaskDefinition;
    private taskRepository: Repository<Task>;
    private taskDefinitionRepository: Repository<TaskDefinition>;

    constructor(
        taskRepository: Repository<Task>,
        taskDefinitionRepository: Repository<TaskDefinition>,
    ) {
        this.taskRepository = taskRepository;
        this.taskDefinitionRepository = taskDefinitionRepository;
    }

    async create(): Promise<Task> {
        const taskDefinition = await this.getTaskDefinition();
        const taskArn = await taskDefinition.runEcsTask(this);
        const task = new Task();
        task.arn = taskArn;
        task.taskDefinitionId = taskDefinition.id;
        task.prNumber = this.prNumber;
        return this.taskRepository.persist(task);
    }

    private async getTaskDefinition(): Promise<TaskDefinition> {
        if (this.taskDefinition) {
            return this.taskDefinition;
        }
        let taskDefinition = await this.taskDefinitionRepository.findOne({ repository: this.repository });
        if (taskDefinition === undefined) {
            taskDefinition = await this.createTaskDefinition();
        }
        this.taskDefinition = taskDefinition;
        return this.taskDefinition;
    }

    private async createTaskDefinition(): Promise<TaskDefinition> {
        const ecs = new ECS();
        const taskDefinitionLoader = new TaskDefinitionLoader(this);
        const taskDefinitionConfig = await taskDefinitionLoader.load();
        return ecs.registerTaskDefinition(taskDefinitionConfig).promise()
            .then((result: AWS.ECS.RegisterTaskDefinitionResponse) => {
                const taskDefinition = new TaskDefinition();
                taskDefinition.name = result.taskDefinition.family;
                taskDefinition.repository = this.repository;
                this.taskDefinitionRepository.persist(taskDefinition);
                return taskDefinition;
            });
    }
}
