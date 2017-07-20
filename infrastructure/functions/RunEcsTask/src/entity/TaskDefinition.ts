import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from "typeorm";

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
}
