package main

import (
	"errors"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/google/go-github/github"
	"github.com/speee/webapp-revieee/src/alb"
	"github.com/speee/webapp-revieee/src/ecs"
	"github.com/speee/webapp-revieee/src/util"
	"log"
)

func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	event, err := github.ParseWebHook(request.Headers["X-Github-Event"], []byte(request.Body))
	if err != nil {
		log.Printf("could not parse webhook: err=%s\n", err)
	}

	e, ok := event.(*github.PullRequestEvent)
	if !ok {
		log.Printf("unknown event type %s\n", request.Headers["X-Github-Event"])
		return events.APIGatewayProxyResponse{}, errors.New("Invalid event")
	}
	log.Printf("Action: %+#v\n", *e.Action)
	log.Printf("Number: %+#v\n", *e.Number)
	log.Printf("Head: %+#v\n", *e.PullRequest.Head.Ref)
	log.Printf("Base: %+#v\n", *e.PullRequest.Base.Ref)
	log.Printf("RepoName: %+#v\n", *e.Repo.FullName)

	repoName := *e.Repo.FullName
	prNumber := *e.Number
	taskDefinition := "test:1"
	uniqueName := util.Md5FromString(fmt.Sprintf("%s%i", repoName, prNumber))
	targetGroupArn := alb.CreateAssociatedTargetGroup(uniqueName)
	ecs.CreateService(uniqueName, taskDefinition, targetGroupArn)

	return events.APIGatewayProxyResponse{
		Body:       fmt.Sprintf("Access, %v", uniqueName),
		StatusCode: 200,
	}, nil
}

func main() {
	lambda.Start(handler)
}
