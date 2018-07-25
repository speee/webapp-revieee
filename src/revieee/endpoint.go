package revieee

import (
	"fmt"
	"crypto/md5"
)

type Endpoint struct {
	Url string
}

func GetEndpoint(target *Target) *Endpoint {
	uniqueName := GetUniqueName(target)

	endpoint := &Endpoint{
		Url: *uniqueName + ".example.com",
	}

	return endpoint
}

func GetUniqueName(target *Target) *string {
	str := fmt.Sprintf("%s/%s#%i", target.RepoOwner, target.RepoName, target.PrNumber)
	uniqueName := fmt.Sprintf("%x", md5.Sum([]byte(str)))
	return &uniqueName
}
