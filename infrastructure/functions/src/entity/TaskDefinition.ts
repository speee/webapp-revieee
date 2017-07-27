import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from "typeorm";
import { ECS } from "aws-sdk";
import { RevieeeTarget } from "./RevieeeTarget";
import { Task } from "./Task";

@Entity("task_definitions")
export class TaskDefinition {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    repository: string;

    @Column()
    name: string;

    @CreateDateColumn({ name: "created_at" })
    createdAt: string;

    @UpdateDateColumn({ name: "updated_at" })
    updatedAt: string;

    async runEcsTask(revieeeTarget: RevieeeTarget): Promise<string> {
        const latestArn = await this.getLatestArn();
        const params: AWS.ECS.RunTaskRequest = {
            cluster: process.env.CLUSTER_NAME,
            taskDefinition: latestArn,
            overrides: {
                containerOverrides: [{
                    name: "main",
                    environment: [{
                        name: "BRANCH",
                        value: revieeeTarget.branch,
                    }],
                }],
            },
        };

        const ecs = new ECS();
        return ecs.runTask(params).promise()
            .then((result: ECS.RunTaskResponse) => {
                return result.tasks[0].taskArn;
            });
    }

    private async getLatestArn(): Promise<string> {
        const params: ECS.ListTaskDefinitionsRequest = {
            familyPrefix: this.name,
            status: "ACTIVE",
            sort: "DESC",
            maxResults: 1,
        };

        const ecs = new ECS();
        return ecs.listTaskDefinitions(params).promise()
            .then((result: ECS.ListTaskDefinitionsResponse) => {
                return result.taskDefinitionArns[0];
            });
    }
}
