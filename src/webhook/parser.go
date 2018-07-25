package webhook

import (
	"errors"
	"github.com/aws/aws-lambda-go/events"
	"github.com/speee/webapp-revieee/src/revieee"
)

func Parse(request events.APIGatewayProxyRequest) (*revieee.Target, error) {
	_, ok := request.Headers["X-Github-Event"]
	if ok {
		return parseGithub(request)
	}

	return nil, errors.New("unknown service")
}
