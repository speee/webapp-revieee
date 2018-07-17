package alb

func CreateAssociatedTargetGroup(name string) (string) {
	targetGroupArn := createTargetGroup(name)
	hostname := name + "." + domain
	priority := getCurrentMaxPriority() + 1
	createRule(targetGroupArn, hostname, priority)
	return targetGroupArn
}
