package alb

import (
	"github.com/speee/webapp-revieee/src/revieee"
)

func CreateAssociatedTargetGroup(target *revieee.Target) (*string, error) {
	targetGroupArn, tgErr := createTargetGroup(target)
	if tgErr != nil {
		return nil, tgErr
	}

	ruleErr := createRule(target, targetGroupArn)
	if ruleErr != nil {
		return nil, ruleErr
	}

	return targetGroupArn, nil
}
