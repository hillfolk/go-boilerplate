package version

import (
	"fmt"
	"strings"

	"go.uber.org/zap"
)

const (
	ServiceName = "go-boilerplate"
)

// All these values will be replaced by actual values at build time.
var (
	GitHash          = "-"
	GitBranch        = "-"
	GitTag           = "-"
	GitCommitMessage = "-"
	BuildTime        = "-"
)

func init() {
	// Since there's an issue passing strings with spaces to ldflags,
	// we replace the strings to _ at build time and here we replace them back.
	GitCommitMessage = strings.Replace(GitCommitMessage, "_", " ", -1)
}

// LogVersion simply prints the current version information to the log
func LogVersion() {
	zap.L().Info(
		fmt.Sprintf(`Version information:
	git-hash: %s
	git-message: %s
	git-branch: %s
	git-tag: %s
	build-time: %s
	`,
			GitHash, GitCommitMessage, GitBranch, GitTag, BuildTime),
		zap.String("git-hash", GitHash),
		zap.String("git-message", GitCommitMessage),
		zap.String("git-branch", GitBranch),
		zap.String("git-tag", GitTag),
		zap.String("build-time", BuildTime),
	)
}
