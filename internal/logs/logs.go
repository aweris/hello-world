package logs

import (
	"os"

	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/log/level"
)

const (
	LogFormatFmt  = "fmt"
	LogFormatJSON = "json"

	LogLevelError = "error"
	LogLevelWarn  = "warn"
	LogLevelInfo  = "info"
	LogLevelDebug = "debug"

	// depth of the caller file and line.
	// Since we wrapped logger instance we need to increase log.DefaultCaller's depth by one.
	loggerDepth = 4
)

// Logger is a wrapper interface for leveled logging entries
type Logger interface {
	Debug(keyvals ...interface{})
	Info(keyvals ...interface{})
	Warn(keyvals ...interface{})
	Error(keyvals ...interface{})
}

// logger simple wrapper object for log.Logger
type logger struct {
	logger log.Logger
}

func NewLogger(logLevel, logFormat, name string) Logger {
	var (
		kitLogger log.Logger
		lvl       level.Option
	)

	switch logLevel {
	case LogLevelError:
		lvl = level.AllowError()
	case LogLevelWarn:
		lvl = level.AllowWarn()
	case LogLevelInfo:
		lvl = level.AllowInfo()
	case LogLevelDebug:
		lvl = level.AllowDebug()
	default:
		panic("unexpected log level")
	}

	switch logFormat {
	case LogFormatJSON:
		kitLogger = log.NewJSONLogger(log.NewSyncWriter(os.Stderr))
	case LogFormatFmt:
		kitLogger = log.NewLogfmtLogger(log.NewSyncWriter(os.Stderr))
	default:
		panic("unexpected log format")
	}

	kitLogger = level.NewFilter(kitLogger, lvl)
	kitLogger = log.With(kitLogger, "name", name)
	kitLogger = log.With(kitLogger, "ts", log.DefaultTimestampUTC, "caller", log.Caller(loggerDepth))

	return &logger{kitLogger}
}

// Debug is a wrapper for level.Debug(logs).Log(keyvals)
func (l *logger) Debug(keyvals ...interface{}) {
	level.Debug(l.logger).Log(keyvals...)
}

// Info is a wrapper for level.Info(logs).Log(keyvals)
func (l *logger) Info(keyvals ...interface{}) {
	level.Info(l.logger).Log(keyvals...)
}

// Warn is a wrapper for level.Warn(logs).Log(keyvals)
func (l *logger) Warn(keyvals ...interface{}) {
	level.Warn(l.logger).Log(keyvals...)
}

// Error is a wrapper for level.Error(logs).Log(keyvals)
func (l *logger) Error(keyvals ...interface{}) {
	level.Error(l.logger).Log(keyvals...)
}
