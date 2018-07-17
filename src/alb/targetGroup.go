package alb

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/elbv2"
)

func createTargetGroup(name string) (string) {
	result, err := svc.CreateTargetGroup(&elbv2.CreateTargetGroupInput{
		Name:     aws.String(name),
		VpcId:		aws.String(vpcId),
		Port:			aws.Int64(80),
		Protocol: aws.String("HTTP"),
	})
	if err != nil {
		handleError(err)
		return ""
	}
	return *result.TargetGroups[0].TargetGroupArn
}
