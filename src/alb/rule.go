package alb

import (
	"sort"
	"strconv"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/elbv2"
	"github.com/speee/webapp-revieee/src/revieee"
)

func createRule(target *revieee.Target, targetGroupArn *string) error {
	endpoint := revieee.GetEndpoint(target)
	priority := getCurrentMaxPriority() + 1

	_, err := svc.CreateRule(&elbv2.CreateRuleInput{
		Actions: []*elbv2.Action{
			{
				TargetGroupArn: aws.String(*targetGroupArn),
				Type:           aws.String("forward"),
			},
		},
		Conditions: []*elbv2.RuleCondition{
			{
				Field: aws.String("host-header"),
				Values: []*string{
					aws.String(endpoint.Url),
				},
			},
		},
		ListenerArn: aws.String(listenerArn),
		Priority:    aws.Int64(priority),
	})
	if err != nil {
		return err
	}

	return nil
}

func getAllRules() []*elbv2.Rule {
	result := []*elbv2.Rule{}
	rules := getRules("")
	result = append(result, rules.Rules...)
	for rules.NextMarker != nil {
		rules = getRules(*rules.NextMarker)
		result = append(result, rules.Rules...)
	}

	return result
}

func getRules(marker string) *elbv2.DescribeRulesOutput {
	result, err := svc.DescribeRules(&elbv2.DescribeRulesInput{
		ListenerArn: aws.String("arn:aws:elasticloadbalancing:ap-northeast-1:127704048019:listener/app/revieee-ALB-MT2OUMA97JM0/6a382ba85a60b939/cc98e3328cf1b2cc"),
		Marker: aws.String(marker),
	})
	if err != nil {
		handleError(err)
		return result
	}

	return result
}

func getPriorities() []int {
	rules := getAllRules()
	result := []int{0}
	for _, rule := range rules {
		if *rule.Priority == "default" {
			continue
		}
		i, _ := strconv.Atoi(*rule.Priority)
		result = append(result, i)
	}
	sort.Ints(result)

	return result
}

func getCurrentMaxPriority() (int64) {
	priorities := getPriorities()

	return int64(priorities[len(priorities)-1])
}
