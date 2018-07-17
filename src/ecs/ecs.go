package ecs

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ecs"
)

func RunTask(taskDefinition string) (string) {
	input := &ecs.RunTaskInput{
		Cluster:        aws.String(clusterName),
		TaskDefinition: aws.String(taskDefinition),
	}

	result, err := svc.RunTask(input)
	if err != nil {
		handleError(err)
		return ""
	}

	return *result.Tasks[0].TaskArn
}

func DescribeTaskPort(taskArn string) (int64) {
	input := &ecs.DescribeTasksInput{
		Cluster: aws.String(clusterName),
		Tasks: []*string{
			aws.String(taskArn),
		},
	}

	runErr := svc.WaitUntilTasksRunning(input)
	if runErr != nil {
		fmt.Println(runErr.Error())
		return 0
	}

	result, err := svc.DescribeTasks(input)
	if err != nil {
		handleError(err)
		return 0
	}

	return *result.Tasks[0].Containers[0].NetworkBindings[0].HostPort
}

func DescribeTaskInstanceId(taskArn string) (string) {
	input := &ecs.DescribeTasksInput{
		Cluster: aws.String(clusterName),
		Tasks: []*string{
			aws.String(taskArn),
		},
	}

	runErr := svc.WaitUntilTasksRunning(input)
	if runErr != nil {
		fmt.Println(runErr.Error())
		return ""
	}

	taskResult, taskErr := svc.DescribeTasks(input)
	if taskErr != nil {
		handleError(taskErr)
		return ""
	}

	result, err := svc.DescribeContainerInstances(&ecs.DescribeContainerInstancesInput{
		Cluster: aws.String(clusterName),
		ContainerInstances: []*string{
			aws.String(*taskResult.Tasks[0].ContainerInstanceArn),
		},
	})
	if err != nil {
		handleError(err)
		return ""
	}

	return *result.ContainerInstances[0].Ec2InstanceId
}
