package main

import (
	"github.com/aweris/hello-world/internal/logs"
	"github.com/aweris/hello-world/version"
)

func main() {
	logger := logs.NewLogger("debug", "fmt", "hello-world")

	version.PrintVersion()

	logger.Debug("msg", "Hello World")
}
