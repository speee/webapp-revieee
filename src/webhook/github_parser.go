package webhook

import (
	"errors"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/google/go-github/github"
	"github.com/speee/webapp-revieee/src/revieee"
)

func parseGithub(request events.APIGatewayProxyRequest) (*revieee.Target, error) {
	event, err := github.ParseWebHook(request.Headers["X-Github-Event"], []byte(request.Body))
	if err != nil {
		return nil, err
	}

	e, ok := event.(*github.PullRequestEvent)
	if !ok {
		return nil, errors.New(fmt.Sprintf("unknown event type %s", request.Headers["X-Github-Event"]))
	}

	var revieeeEvent revieee.Event
	switch *e.Action {
	case "opened":
		revieeeEvent = revieee.Create
	default:
		return nil, errors.New(fmt.Sprintf("unknown event action %s", *e.Action))
	}

	target := &revieee.Target{
		Event: revieeeEvent,
		Service: revieee.Github,
		RepoOwner: e.Repo.Owner.Login,
		RepoName: e.Repo.Name,
		PrNumber: e.Number,
	}

	return target, nil
}
