package ecs

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ecs"
)

var (
	svc = ecs.New(session.New())
	clusterName = "revieee-v2-EcsCluster-1G96GH7NHYX82"
)

func handleError(err error) {
	if aerr, ok := err.(awserr.Error); ok {
		switch aerr.Code() {
		case ecs.ErrCodeServerException:
			fmt.Println(ecs.ErrCodeServerException, aerr.Error())
		case ecs.ErrCodeClientException:
			fmt.Println(ecs.ErrCodeClientException, aerr.Error())
		case ecs.ErrCodeInvalidParameterException:
			fmt.Println(ecs.ErrCodeInvalidParameterException, aerr.Error())
		case ecs.ErrCodeClusterNotFoundException:
			fmt.Println(ecs.ErrCodeClusterNotFoundException, aerr.Error())
		case ecs.ErrCodeUnsupportedFeatureException:
			fmt.Println(ecs.ErrCodeUnsupportedFeatureException, aerr.Error())
		case ecs.ErrCodePlatformUnknownException:
			fmt.Println(ecs.ErrCodePlatformUnknownException, aerr.Error())
		case ecs.ErrCodePlatformTaskDefinitionIncompatibilityException:
			fmt.Println(ecs.ErrCodePlatformTaskDefinitionIncompatibilityException, aerr.Error())
		case ecs.ErrCodeAccessDeniedException:
			fmt.Println(ecs.ErrCodeAccessDeniedException, aerr.Error())
		default:
			fmt.Println(aerr.Error())
		}
	} else {
		fmt.Println(err.Error())
	}
}
