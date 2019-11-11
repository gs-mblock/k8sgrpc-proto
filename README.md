# hellogrpc3

grpc test,k8s 部署最简单的grpc server;

## tool

export PROJECT_ENV="localhost" && go run main.go
echo $GRPC_HOST

## install

go mod tidy

## run

go run main.go

## install

go mod tidy

## test

通过客户端测试

## 使用

1. docker 发布：deploy/docker-image.sh
2. docker test： docker-compose up
3. k8s test：k8s-dev-c.sh
