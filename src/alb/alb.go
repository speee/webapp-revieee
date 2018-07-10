package alb

import (
	"fmt"
	"crypto/md5"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/service/elbv2"
)

var (
	svc = elbv2.New(session.New())
	vpcId = "vpc-25463d42"
	listenerArn = "arn:aws:elasticloadbalancing:ap-northeast-1:127704048019:listener/app/revieee-ALB-MT2OUMA97JM0/6a382ba85a60b939/cc98e3328cf1b2cc"
	clusterName = "revieee-v2-EcsCluster-1G96GH7NHYX82"
)

func Register(prNumber int64, instanceId string, port int64) {
	md5Hash := fmt.Sprintf("%x", md5.Sum([]byte(string(prNumber))))
	targetGroupArn := createTargetGroup(md5Hash)
	fmt.Println(targetGroupArn)
	registerTarget(targetGroupArn, instanceId, port)
}

func createTargetGroup(name string) (string) {
	input := &elbv2.CreateTargetGroupInput{
		Name:     aws.String(name),
		VpcId:		aws.String(vpcId),
		Port:			aws.Int64(80),
		Protocol: aws.String("HTTP"),
	}

	result, err := svc.CreateTargetGroup(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			case elbv2.ErrCodeDuplicateTargetGroupNameException:
				fmt.Println(elbv2.ErrCodeDuplicateTargetGroupNameException, aerr.Error())
			case elbv2.ErrCodeTooManyTargetGroupsException:
				fmt.Println(elbv2.ErrCodeTooManyTargetGroupsException, aerr.Error())
			case elbv2.ErrCodeInvalidConfigurationRequestException:
				fmt.Println(elbv2.ErrCodeInvalidConfigurationRequestException, aerr.Error())
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			fmt.Println(err.Error())
		}
		return ""
	}
	return *result.TargetGroups[0].TargetGroupArn
}

func registerTarget(targetGroupArn string, instanceId string, port int64) {
	input := &elbv2.RegisterTargetsInput{
		TargetGroupArn: aws.String(targetGroupArn),
		Targets: []*elbv2.TargetDescription{
			{
				Id:   aws.String(instanceId),
				Port: aws.Int64(port),
			},
		},
	}

	result, err := svc.RegisterTargets(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			case elbv2.ErrCodeTargetGroupNotFoundException:
				fmt.Println(elbv2.ErrCodeTargetGroupNotFoundException, aerr.Error())
			case elbv2.ErrCodeTooManyTargetsException:
				fmt.Println(elbv2.ErrCodeTooManyTargetsException, aerr.Error())
			case elbv2.ErrCodeInvalidTargetException:
				fmt.Println(elbv2.ErrCodeInvalidTargetException, aerr.Error())
			case elbv2.ErrCodeTooManyRegistrationsForTargetIdException:
				fmt.Println(elbv2.ErrCodeTooManyRegistrationsForTargetIdException, aerr.Error())
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			fmt.Println(err.Error())
		}
		return
	}

	fmt.Println(result)
}

// func createRule(string targetGroupArn, string hostName) {
// 	input := &elbv2.CreateRuleInput{
// 		Actions: []*elbv2.Action{
// 			{
// 				TargetGroupArn: targetGroupArn,
// 				Type:           "forward",
// 			},
// 		},
// 		Conditions: []*elbv2.RuleCondition{
// 			{
// 				Field: "host-header",
// 				Values: []*string{
// 					hostName,
// 				},
// 			},
// 		},
// 		ListenerArn: listenerArn,
// 		Priority:    aws.Int64(10),
// 	}

// 	result, err := svc.CreateRule(input)
// 	if err != nil {
// 		if aerr, ok := err.(awserr.Error); ok {
// 			switch aerr.Code() {
// 			case elbv2.ErrCodePriorityInUseException:
// 				fmt.Println(elbv2.ErrCodePriorityInUseException, aerr.Error())
// 			case elbv2.ErrCodeTooManyTargetGroupsException:
// 				fmt.Println(elbv2.ErrCodeTooManyTargetGroupsException, aerr.Error())
// 			case elbv2.ErrCodeTooManyRulesException:
// 				fmt.Println(elbv2.ErrCodeTooManyRulesException, aerr.Error())
// 			case elbv2.ErrCodeTargetGroupAssociationLimitException:
// 				fmt.Println(elbv2.ErrCodeTargetGroupAssociationLimitException, aerr.Error())
// 			case elbv2.ErrCodeIncompatibleProtocolsException:
// 				fmt.Println(elbv2.ErrCodeIncompatibleProtocolsException, aerr.Error())
// 			case elbv2.ErrCodeListenerNotFoundException:
// 				fmt.Println(elbv2.ErrCodeListenerNotFoundException, aerr.Error())
// 			case elbv2.ErrCodeTargetGroupNotFoundException:
// 				fmt.Println(elbv2.ErrCodeTargetGroupNotFoundException, aerr.Error())
// 			case elbv2.ErrCodeInvalidConfigurationRequestException:
// 				fmt.Println(elbv2.ErrCodeInvalidConfigurationRequestException, aerr.Error())
// 			case elbv2.ErrCodeTooManyRegistrationsForTargetIdException:
// 				fmt.Println(elbv2.ErrCodeTooManyRegistrationsForTargetIdException, aerr.Error())
// 			case elbv2.ErrCodeTooManyTargetsException:
// 				fmt.Println(elbv2.ErrCodeTooManyTargetsException, aerr.Error())
// 			case elbv2.ErrCodeUnsupportedProtocolException:
// 				fmt.Println(elbv2.ErrCodeUnsupportedProtocolException, aerr.Error())
// 			case elbv2.ErrCodeTooManyActionsException:
// 				fmt.Println(elbv2.ErrCodeTooManyActionsException, aerr.Error())
// 			case elbv2.ErrCodeInvalidLoadBalancerActionException:
// 				fmt.Println(elbv2.ErrCodeInvalidLoadBalancerActionException, aerr.Error())
// 			default:
// 				fmt.Println(aerr.Error())
// 			}
// 		} else {
// 			// Print the error, cast err to awserr.Error to get the Code and
// 			// Message from an error.
// 			fmt.Println(err.Error())
// 		}
// 		return
// 	}

// 	fmt.Println(result)
// }

// func getRules() {
// 	input := &elbv2.DescribeListenersInput{
// 		ListenerArns: []*string{
// 			aws.String("arn:aws:elasticloadbalancing:us-west-2:123456789012:listener/app/my-load-balancer/50dc6c495c0c9188/f2f7dc8efc522ab2"),
// 		},
// 	}

// 	result, err := svc.DescribeListeners(input)
// 	if err != nil {
// 		if aerr, ok := err.(awserr.Error); ok {
// 			switch aerr.Code() {
// 			case elbv2.ErrCodeListenerNotFoundException:
// 				fmt.Println(elbv2.ErrCodeListenerNotFoundException, aerr.Error())
// 			case elbv2.ErrCodeLoadBalancerNotFoundException:
// 				fmt.Println(elbv2.ErrCodeLoadBalancerNotFoundException, aerr.Error())
// 			case elbv2.ErrCodeUnsupportedProtocolException:
// 				fmt.Println(elbv2.ErrCodeUnsupportedProtocolException, aerr.Error())
// 			default:
// 				fmt.Println(aerr.Error())
// 			}
// 		} else {
// 			// Print the error, cast err to awserr.Error to get the Code and
// 			// Message from an error.
// 			fmt.Println(err.Error())
// 		}
// 		return
// 	}

// 	fmt.Println(result)
// }

// func getPriorities() ([]*int) {
// 	input := &elbv2.DescribeRulesInput{
// 		RuleArns: []*string{
// 			aws.String("arn:aws:elasticloadbalancing:us-west-2:123456789012:listener-rule/app/my-load-balancer/50dc6c495c0c9188/f2f7dc8efc522ab2/9683b2d02a6cabee"),
// 		},
// 	}

// 	result, err := svc.DescribeRules(input)
// 	if err != nil {
// 		if aerr, ok := err.(awserr.Error); ok {
// 			switch aerr.Code() {
// 			case elbv2.ErrCodeListenerNotFoundException:
// 				fmt.Println(elbv2.ErrCodeListenerNotFoundException, aerr.Error())
// 			case elbv2.ErrCodeRuleNotFoundException:
// 				fmt.Println(elbv2.ErrCodeRuleNotFoundException, aerr.Error())
// 			case elbv2.ErrCodeUnsupportedProtocolException:
// 				fmt.Println(elbv2.ErrCodeUnsupportedProtocolException, aerr.Error())
// 			default:
// 				fmt.Println(aerr.Error())
// 			}
// 		} else {
// 			// Print the error, cast err to awserr.Error to get the Code and
// 			// Message from an error.
// 			fmt.Println(err.Error())
// 		}
// 		return
// 	}

// 	fmt.Println(result)
// }
