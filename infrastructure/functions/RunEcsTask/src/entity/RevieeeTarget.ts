import { ECS } from "aws-sdk";
import { Repository } from "typeorm";
import { TaskDefinition } from "./TaskDefinition";
import { TaskDefinitionLoader } from "../TaskDefinitionLoader";

export class RevieeeTarget {
    repository: string;
    branch: string;
    prNumber: number;
    private taskDefinition: TaskDefinition;
    private taskDefinitionRepository: Repository<TaskDefinition>;

    constructor(
        taskDefinitionRepository: Repository<TaskDefinition>,
    ) {
        this.taskDefinitionRepository = taskDefinitionRepository;
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
