import { ECS } from "aws-sdk";
import * as GitHub from "github-api";
import * as YAML from "js-yaml";
import { RevieeeTarget } from "./entity/RevieeeTarget";

export class TaskDefinitionLoader {
    readonly configFile = "task_definition.yml";
    revieeeTarget: RevieeeTarget;

    constructor(revieeeTarget: RevieeeTarget) {
        this.revieeeTarget = revieeeTarget;
    }

    async load(): Promise<ECS.RegisterTaskDefinitionRequest> {
        const gh = new GitHub({ token: process.env.GITHUB_ACCESS_TOKEN });
        const repository = gh.getRepo(this.revieeeTarget.repository);
        return repository.getContents(
            this.revieeeTarget.branch,
            this.configFile,
        ).then(async result => {
            return await this.parseContent(result.data.content);
        });
    }

    private async parseContent(content: string): Promise<ECS.RegisterTaskDefinitionRequest> {
        const parsedContent = new Buffer(content, 'base64').toString();
        const json = YAML.safeLoad(parsedContent);
        return this.camelizeKeys(json);
    }

    private camelizeKeys = (obj) => {
        if (!obj || typeof obj !== 'object') return obj;
        if (Array.isArray(obj)) return obj.map(this.camelizeKeys);
        const newObj = {};
        Object.keys(obj).forEach((key: string) => {
            newObj[this.camelizeStr(key)] = this.camelizeKeys(obj[key]);
        });
        return newObj;
    }

    private camelizeStr = (str: string): string => {
        return str.replace(/[_](\w|$)/g, (_, x) => {
            return x.toUpperCase();
        });
    }
}
