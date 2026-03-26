package log

import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var logger *zap.Logger
var sugar *zap.SugaredLogger

// Setup logging
func Setup(useJSON bool) {
	var config zap.Config

	if useJSON {
		config = zap.NewProductionConfig()
		config.OutputPaths = []string{"stderr"}
		config.ErrorOutputPaths = []string{"stderr"}
	} else {
		config = zap.NewDevelopmentConfig()
		config.OutputPaths = []string{"stderr"}
		config.ErrorOutputPaths = []string{"stderr"}
		config.EncoderConfig.EncodeLevel = zapcore.CapitalColorLevelEncoder
		config.EncoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	}

	var err error
	logger, err = config.Build()
	if err != nil {
		panic(err)
	}
	sugar = logger.Sugar()

	zap.ReplaceGlobals(logger)
}

// Logger returns the global logger instance
func Logger() *zap.Logger {
	return logger
}

// Sugar returns the global sugared logger instance
func Sugar() *zap.SugaredLogger {
	return sugar
}

// Sync flushes any buffered log entries
func Sync() {
	if logger != nil {
		_ = logger.Sync()
	}
}
