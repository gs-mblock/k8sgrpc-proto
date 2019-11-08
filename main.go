package main

import (
	"hellogrpc3/app"
	"hellogrpc3/pkg/configs"
	"log"
	"os"
	"os/signal"
)

func main() {
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)

	app.RunServer(":" + configs.EnvConfig.ServerGRPCPort)

	quit := make(chan os.Signal)
	signal.Notify(quit, os.Interrupt)
	<-quit
	log.Println("Shutdown Server ...")
}
