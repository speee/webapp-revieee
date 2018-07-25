package ecs

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ecs"
	"github.com/speee/webapp-revieee/src/revieee"
)

func CreateService(target *revieee.Target, targetGroupArn *string) error {
	uniqueName := revieee.GetUniqueName(target)
	taskDefinition := getTaskDefinition()
	_, err := svc.CreateService(&ecs.CreateServiceInput{
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
				TargetGroupArn: aws.String(*targetGroupArn),
			},
		},
		ServiceName:    aws.String(*uniqueName),
		TaskDefinition: aws.String(taskDefinition),
	})
	if err != nil {
		return err
	}

	return nil
}
