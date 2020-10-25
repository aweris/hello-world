# Project directories
ROOT_DIR := $(CURDIR)

# External targets
include .bingo/Variables.mk
include scripts/make/help.mk
include scripts/make/lint.mk
include scripts/make/build.mk
include scripts/make/test.mk

# Commands used in Makefile
GOCMD           := go
GOINSTALL       := $(GOCMD) install

# Helper variables
V = 0
Q = $(if $(filter 1,$V),,@)
M = $(shell printf "\033[34;1m▶\033[0m")