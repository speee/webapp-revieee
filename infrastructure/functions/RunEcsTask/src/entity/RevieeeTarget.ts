import { Repository } from "typeorm";
import { TaskDefinition } from "./TaskDefinition";
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
        this.taskDefinition = taskDefinition;
        return this.taskDefinition;
    }
}
