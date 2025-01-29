/*
Copyright © 2025 Hillfolk <pjy1418@gmail.com>
*/
package main

import (
	"github.com/common-nighthawk/go-figure"

	"github.com/hillfolk/go-boilerplate/cmd"
	"github.com/hillfolk/go-boilerplate/log"
	"github.com/hillfolk/go-boilerplate/version"
)

func main() {

	log.Setup(false)

	splash := figure.NewColorFigure(version.ServiceName, "", "green", false)
	splash.Print()
	version.LogVersion()
	cmd.Execute()
}
