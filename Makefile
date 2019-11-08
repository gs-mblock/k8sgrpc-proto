SHELL := /bin/bash
BASEDIR = $(shell pwd)
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
export GOPRIVATE=*.gitlab.com
export GOSUMDB=off

APP_NAME=`node -p "require('./package.json').name"`
APP_VERSION=`node -p "require('./package.json').version"`
COMMIT_ID=`git rev-parse HEAD`
IMAGE_PREFIX="registry.cn-hangzhou.aliyuncs.com/makeblock/${APP_NAME}:v${APP_VERSION}"

all: fmt
	go build -o ${APP_NAME} main.go
first:
	# 代码关系检测
	go get github.com/TrueFurby/go-callvis
	# 代码修改自动重启
	go get github.com/oxequa/realize
fmt:
	gofmt -w .
dev:
	realize start
callvis:
	#	需要安装graphviz https://github.com/TrueFurby/go-callvis#requirements
	#   brew install graphviz
	go-callvis -format png -file main .
utest:
	go mod tidy; \
	go test -coverpkg=./... -coverprofile=coverage.data ./...;
build:
	go mod tidy; \
	cd deploy/docker;  \
	rm -rf build | echo "no build dir"; \
	mkdir build; \
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '-w -s' -o build/main ../../main.go;
build-master: build
	IMAGE_NAME="${IMAGE_PREFIX}-master"; \
	echo $$IMAGE_NAME; \
	cd deploy/docker;  \
	docker build --build-arg tmp_api_version=${COMMIT_ID} -t $$IMAGE_NAME -f Dockerfile .; \
	docker push $$IMAGE_NAME;
build-release: build
	IMAGE_NAME="${IMAGE_PREFIX}-release"; \
	echo $$IMAGE_NAME; \
	cd deploy/docker;  \
	docker build --build-arg tmp_api_version=${COMMIT_ID} -t $$IMAGE_NAME -f Dockerfile .; \
	docker push $$IMAGE_NAME;
deploy-dev:
	NEW_IMAGE="${APP_NAME}=${IMAGE_PREFIX}-master"; \
	cd deploy/kubernetes/base; \
	kustomize edit set image $$NEW_IMAGE; \
	kustomize edit add annotation git.commit.id:${COMMIT_ID}
	kubectl config use aliyun-test
	kustomize build deploy/kubernetes/overlays/dev
	kustomize build deploy/kubernetes/overlays/dev | kubectl apply -f -
deploy-test:
	NEW_IMAGE="${APP_NAME}=${IMAGE_PREFIX}-release"; \
	cd deploy/kubernetes/base; \
	kustomize edit set image $$NEW_IMAGE; \
	kustomize edit add annotation git.commit.id:${COMMIT_ID}
	kubectl config use aliyun-test
	kustomize build deploy/kubernetes/overlays/test
	kustomize build deploy/kubernetes/overlays/test | kubectl apply -f -
deploy-prod:
	kubectl config use aliyun
	kustomize build deploy/kubernetes/overlays/prod | kubectl apply -f -
deploy-prod-preview:
	NEW_IMAGE="${APP_NAME}=${IMAGE_PREFIX}-release"; \
	cd deploy/kubernetes/base; \
	kustomize edit set image $$NEW_IMAGE; \
	kustomize edit add annotation git.commit.id:${COMMIT_ID};
	kustomize build deploy/kubernetes/overlays/prod
help:
	@echo "make - compile the source code"
	@echo "make clean - remove binary file and vim swp files"