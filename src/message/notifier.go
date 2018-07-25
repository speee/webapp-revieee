package message

import (
	"github.com/speee/webapp-revieee/src/revieee"
)

func Notify(target *revieee.Target) error {
	return notifyGithub(target)
}
