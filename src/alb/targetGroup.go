package alb

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/elbv2"
	"github.com/speee/webapp-revieee/src/revieee"
)

func createTargetGroup(target *revieee.Target) (*string, error) {
	uniqueName := revieee.GetUniqueName(target)
	result, err := svc.CreateTargetGroup(&elbv2.CreateTargetGroupInput{
		Name:     aws.String(*uniqueName),
		VpcId:		aws.String(vpcId),
		Port:			aws.Int64(80),
		Protocol: aws.String("HTTP"),
	})
	if err != nil {
		return nil, err
	}
	return result.TargetGroups[0].TargetGroupArn, nil
}
