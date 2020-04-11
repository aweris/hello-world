package main

import (
	"fmt"
	"os"

	"github.com/aweris/hello-world/logs"
	"github.com/aweris/hello-world/version"
)

func main() {
	logger, err := logs.NewLogger(logs.DEBUG)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	logger.Debug("msg", "Hello World", "version", version.Version, "BuildDate", version.BuildDate)
}
