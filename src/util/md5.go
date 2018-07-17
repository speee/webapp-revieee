package util

import (
	"fmt"
	"crypto/md5"
)

func Md5FromString(str string) (string) {
	return fmt.Sprintf("%x", md5.Sum([]byte(str)))
}
