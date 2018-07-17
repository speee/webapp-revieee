package alb

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/service/elbv2"
)

var (
	svc = elbv2.New(session.New())
	vpcId = "vpc-25463d42"
	listenerArn = "arn:aws:elasticloadbalancing:ap-northeast-1:127704048019:listener/app/revieee-ALB-MT2OUMA97JM0/6a382ba85a60b939/cc98e3328cf1b2cc"
	clusterName = "revieee-v2-EcsCluster-1G96GH7NHYX82"
	domain = "example.com"
)

func handleError(err error) {
	if aerr, ok := err.(awserr.Error); ok {
		switch aerr.Code() {
		case elbv2.ErrCodeDuplicateTargetGroupNameException:
			fmt.Println(elbv2.ErrCodeDuplicateTargetGroupNameException, aerr.Error())
		case elbv2.ErrCodeTooManyTargetGroupsException:
			fmt.Println(elbv2.ErrCodeTooManyTargetGroupsException, aerr.Error())
		case elbv2.ErrCodeInvalidConfigurationRequestException:
			fmt.Println(elbv2.ErrCodeInvalidConfigurationRequestException, aerr.Error())
		case elbv2.ErrCodeTargetGroupNotFoundException:
			fmt.Println(elbv2.ErrCodeTargetGroupNotFoundException, aerr.Error())
		case elbv2.ErrCodeTooManyTargetsException:
			fmt.Println(elbv2.ErrCodeTooManyTargetsException, aerr.Error())
		case elbv2.ErrCodeInvalidTargetException:
			fmt.Println(elbv2.ErrCodeInvalidTargetException, aerr.Error())
		case elbv2.ErrCodeTooManyRegistrationsForTargetIdException:
			fmt.Println(elbv2.ErrCodeTooManyRegistrationsForTargetIdException, aerr.Error())
		case elbv2.ErrCodePriorityInUseException:
			fmt.Println(elbv2.ErrCodePriorityInUseException, aerr.Error())
		case elbv2.ErrCodeTooManyRulesException:
			fmt.Println(elbv2.ErrCodeTooManyRulesException, aerr.Error())
		case elbv2.ErrCodeTargetGroupAssociationLimitException:
			fmt.Println(elbv2.ErrCodeTargetGroupAssociationLimitException, aerr.Error())
		case elbv2.ErrCodeIncompatibleProtocolsException:
			fmt.Println(elbv2.ErrCodeIncompatibleProtocolsException, aerr.Error())
		case elbv2.ErrCodeListenerNotFoundException:
			fmt.Println(elbv2.ErrCodeListenerNotFoundException, aerr.Error())
		case elbv2.ErrCodeUnsupportedProtocolException:
			fmt.Println(elbv2.ErrCodeUnsupportedProtocolException, aerr.Error())
		case elbv2.ErrCodeTooManyActionsException:
			fmt.Println(elbv2.ErrCodeTooManyActionsException, aerr.Error())
		case elbv2.ErrCodeInvalidLoadBalancerActionException:
			fmt.Println(elbv2.ErrCodeInvalidLoadBalancerActionException, aerr.Error())
		case elbv2.ErrCodeLoadBalancerNotFoundException:
			fmt.Println(elbv2.ErrCodeLoadBalancerNotFoundException, aerr.Error())
		case elbv2.ErrCodeRuleNotFoundException:
			fmt.Println(elbv2.ErrCodeRuleNotFoundException, aerr.Error())
		default:
			fmt.Println(aerr.Error())
		}
	} else {
		fmt.Println(err.Error())
	}
}
