package logs

import (
	"fmt"
	"os"

	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/log/level"
)

type Level int

const (
	// possible logging levels for logger
	DEBUG Level = iota
	INFO
	WARN
	ERROR
	NONE

	// depth of the caller file and line.
	// Since we wrapped logger instance we need to increase log.DefaultCaller's depth by one.
	loggerDepth = 4
)

func (l Level) String() string {
	return [...]string{"DEBUG", "INFO", "WARN", "ERROR", "NONE"}[l]
}

// Logger is a wrapper interface for leveled logging entries
type Logger interface {
	Debug(keyvals ...interface{})
	Info(keyvals ...interface{})
	Warn(keyvals ...interface{})
	Error(keyvals ...interface{})
}

// Logger simple wrapper object for log.Logger
type logger struct {
	logger log.Logger
}

// NewLogger returns new logger instance
func NewLogger(logLevel Level) (Logger, error) {
	kitLogger := log.NewLogfmtLogger(log.NewSyncWriter(os.Stdout))

	switch logLevel {
	case DEBUG:
		kitLogger = level.NewFilter(kitLogger, level.AllowDebug())
	case INFO:
		kitLogger = level.NewFilter(kitLogger, level.AllowInfo())
	case WARN:
		kitLogger = level.NewFilter(kitLogger, level.AllowWarn())
	case ERROR:
		kitLogger = level.NewFilter(kitLogger, level.AllowError())
	case NONE:
		kitLogger = level.NewFilter(kitLogger, level.AllowNone())
	default:
		return nil, fmt.Errorf(
			"log level %v unknown, %v are possible values",
			logLevel,
			[]Level{
				DEBUG,
				INFO,
				WARN,
				ERROR,
				NONE,
			},
		)
	}

	kitLogger = log.With(kitLogger, "ts", log.DefaultTimestampUTC)
	kitLogger = log.With(kitLogger, "caller", log.Caller(loggerDepth))

	return &logger{kitLogger}, nil
}

// Debug is a wrapper for level.Debug(logger).Log(keyvals)
func (l *logger) Debug(keyvals ...interface{}) {
	level.Debug(l.logger).Log(keyvals...)
}

// Info is a wrapper for level.Info(logger).Log(keyvals)
func (l *logger) Info(keyvals ...interface{}) {
	level.Info(l.logger).Log(keyvals...)
}

// Warn is a wrapper for level.Warn(logger).Log(keyvals)
func (l *logger) Warn(keyvals ...interface{}) {
	level.Warn(l.logger).Log(keyvals...)
}

// Error is a wrapper for level.Error(logger).Log(keyvals)
func (l *logger) Error(keyvals ...interface{}) {
	level.Error(l.logger).Log(keyvals...)
}
