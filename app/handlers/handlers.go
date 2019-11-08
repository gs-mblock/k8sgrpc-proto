package handlers

import (
	"context"
	"hellogrpc3/proto"
)

// GrpcServer implementation for authservice.proto
type GrpcServer struct{}

// SayHello implementation for demo.proto
func (s *GrpcServer) SayHello(ctx context.Context, r *proto.SayHelloReq) (*proto.SayHelloResp, error) {
	return &proto.SayHelloResp{Ok: true}, nil
}
