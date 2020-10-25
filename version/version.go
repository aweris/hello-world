// Package version provides the git commit id and build date of the dta
package version

import "fmt"

// Version represents the software version of the
// nolint:gochecknoglobals
var (
	Version = "dev"
	Commit  = "none"
	Date    = "unknown"
)

func PrintVersion() {
	fmt.Printf("Version    : %s\n", Version)
	fmt.Printf("Git Commit : %s\n", Commit)
	fmt.Printf("Build Date : %s\n", Date)
}
