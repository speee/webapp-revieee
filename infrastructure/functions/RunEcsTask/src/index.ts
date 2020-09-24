import { Callback, Context } from "aws-lambda";
import * as AWS from "aws-sdk";

const ecs = new AWS.ECS();

export function handler(event: any, context: Context, callback: Callback) {
  const envBranch: AWS.ECS.KeyValuePair = {
    name: "BRANCH",
    value: "master",
  };
  const containerOverride: AWS.ECS.ContainerOverride = {
    name: "main",
    environment: [envBranch],
  };
  const taskOverride: AWS.ECS.TaskOverride = {
    containerOverrides: [containerOverride],
  };
  const params: AWS.ECS.RunTaskRequest = {
    cluster: "revieee",
    taskDefinition: "REPLACE_ME_ARN_OF_TASK_DEFINITION",
    overrides: taskOverride,
  };

  (async () => {
    return await ecs.runTask(params).promise();
  })().then((result: AWS.ECS.RunTaskResponse) => {
    console.log(result.tasks);
    callback(null, result.tasks[0].taskArn);
  }).catch((err: AWS.AWSError) => {
    callback(err);
  });
}
