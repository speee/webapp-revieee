.PHONY: deps clean build package deploy test output check_go check_sam check_env_bucket_name check_env_stack_name

deps: check_go
	go get -u ./...

clean:
	rm -rf ./build

build: check_go
	GOOS=linux GOARCH=amd64 go build -o build/main ./src

package: check_sam check_env_bucket_name test clean build
	sam package --template-file template.yml --output-template-file build/packaged.yml --s3-bucket $(BUCKET_NAME)

deploy: check_env_stack_name package
	sam deploy --template-file build/packaged.yml --stack-name $(STACK_NAME) --capabilities CAPABILITY_IAM
	@ $(MAKE) output

test: check_sam
	sam validate --template template.yml

output: check_aws check_env_stack_name
	aws cloudformation describe-stacks --stack-name $(STACK_NAME) --query 'Stacks[].Outputs[]'

check_go:
	@ if [ -z "`go version 2> /dev/null`" ]; then echo 'Please install go https://golang.org/'; exit 1; fi

check_sam:
	@ if [ -z "`sam --version 2> /dev/null`" ]; then echo 'Please install sam-cli https://github.com/awslabs/aws-sam-cli'; exit 1; fi

check_aws:
	@ if [ -z "`aws help 2> /dev/null`" ]; then echo 'Please install aws-cli https://github.com/aws/aws-cli'; exit 1; fi

check_env_bucket_name:
	@ if [ -z $(BUCKET_NAME) ]; then echo 'Environment BUCKET_NAME is required'; exit 1; fi

check_env_stack_name:
	@ if [ -z $(STACK_NAME) ]; then echo 'Environment STACK_NAME is required'; exit 1; fi
