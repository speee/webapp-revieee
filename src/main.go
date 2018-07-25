package main

import (
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/speee/webapp-revieee/src/message"
	"github.com/speee/webapp-revieee/src/revieee"
	"github.com/speee/webapp-revieee/src/webhook"
	"github.com/speee/webapp-revieee/src/alb"
	"github.com/speee/webapp-revieee/src/ecs"
)

func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	target, parseErr := webhook.Parse(request)
	if parseErr != nil {
		return events.APIGatewayProxyResponse{}, parseErr
	}

	handleErr:= handle(target)
	if handleErr != nil {
		return events.APIGatewayProxyResponse{}, handleErr
	}

	notifyErr := message.Notify(target)
	if notifyErr != nil {
		return events.APIGatewayProxyResponse{}, notifyErr
	}

	return events.APIGatewayProxyResponse{
		Body:       fmt.Sprintf("Revieee %s", target.Event),
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handler)
}

func handle(target *revieee.Target) error {
	targetGroupArn, tgErr := alb.CreateAssociatedTargetGroup(target)
	if tgErr != nil {
		return tgErr
	}

	serviceErr := ecs.CreateService(target, targetGroupArn)
	if serviceErr != nil {
		return serviceErr
	}

	return nil
}
