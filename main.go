package main

import (
	"github.com/aweris/hello-world/internal/logs"
	"github.com/aweris/hello-world/version"
)

func main() {
	logger := logs.NewLogger("debug", "fmt", "hello-world")

	logger.Debug("msg", "Hello World", "version", version.Version, "BuildDate", version.BuildDate)
}
