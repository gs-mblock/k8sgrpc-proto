package handlers

import (
	"context"
	"fmt"
	"k8sgrpcsv/proto"
	"os"
)

// GrpcServer implementation for authservice.proto
type GrpcServer struct{}

// SayHello implementation for demo.proto
func (s *GrpcServer) SayHello(ctx context.Context, r *proto.SayHelloReq) (*proto.SayHelloResp, error) {
	fmt.Printf("SayHello:%+v\n", r)
	serviceHostname, _ := os.Hostname()
	return &proto.SayHelloResp{Ok: true, Name: r.Name, Host: serviceHostname}, nil
}
