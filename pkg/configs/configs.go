package configs

import (
	"fmt"

	"github.com/timest/env"
)

//EnvConfig EnvConfig
var EnvConfig *config

type config struct {
	ProjectEnv string `env:"PROJECT_ENV" default:"dev"`
	Mysql      struct {
		Host   string `default:"rm-wz912s848qk08h72ceo.mysql.rds.aliyuncs.com"`
		Port   string `default:"3306"`
		DBName string `default:"k8sgrpcsv"`
		User   string `default:"root"`
		Pwd    string `default:"Makeblock123"`
	}
	Redis struct {
		Host   string `default:"120.78.51.14"`
		Port   string `default:"7000"`
		Pwd    string `default:""`
		Prefix string `default:"k8sgrpcsv|"`
	}
	// my
	ServerGRPCPort string `env:"SERVER_GRPC_Port" default:"7000"`
	GrpcUser       string `env:"GRPC_USER" default:"localhost:7000"`
}

func init() {
	EnvConfig = new(config)
	env.IgnorePrefix()
	err := env.Fill(EnvConfig)
	fmt.Printf("evn:%+v\n", EnvConfig)
	if err != nil {
		panic(err)
	}
}
