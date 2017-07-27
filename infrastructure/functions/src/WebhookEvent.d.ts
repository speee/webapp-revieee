export declare interface WebhookEvent {
    action: string;
    prNumber: number;
    headRepository: string;
    headBranch: string;
    baseRepository: string;
    baseBranch: string;
}
