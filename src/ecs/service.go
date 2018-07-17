package ecs

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ecs"
)

func CreateService(name string, taskDefinition string, targetGroupArn string) (string) {
	result, err := svc.CreateService(&ecs.CreateServiceInput{
		Cluster:        aws.String(clusterName),
		DeploymentConfiguration: &ecs.DeploymentConfiguration{
			MaximumPercent: aws.Int64(200),
			MinimumHealthyPercent: aws.Int64(100),
		},
		DesiredCount:   aws.Int64(1),
		LoadBalancers: []*ecs.LoadBalancer{
			{
				ContainerName:    aws.String("nginx"),
				ContainerPort:    aws.Int64(80),
				TargetGroupArn: aws.String(targetGroupArn),
			},
		},
		ServiceName:    aws.String(name),
		TaskDefinition: aws.String(taskDefinition),
	})
	if err != nil {
		handleError(err)
		return ""
	}

	fmt.Println(result)
	return ""
}
