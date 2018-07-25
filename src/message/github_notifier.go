package message

import (
	"context"
	// "errors"
	"github.com/google/go-github/github"
	"github.com/speee/webapp-revieee/src/revieee"
	"golang.org/x/oauth2"
	"os"
)

func notifyGithub(target *revieee.Target) error {
	token := os.Getenv("GITHUB_ACCESS_TOKEN")
	// if token == "" {
	// 	return errors.New("undefined github token")
	// }

	ctx := context.Background()
	ts := oauth2.StaticTokenSource(
		&oauth2.Token{AccessToken: token},
	)
	tc := oauth2.NewClient(ctx, ts)
	client := github.NewClient(tc)
	endpoint := revieee.GetEndpoint(target)
	client.Issues.CreateComment(
		ctx,
		*target.RepoOwner,
		*target.RepoName,
		*target.PrNumber,
		&github.IssueComment{Body: &endpoint.Url},
	)
	return nil
}
