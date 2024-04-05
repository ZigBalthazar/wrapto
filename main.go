package main

import (
	"context"
	"os"

	"github.com/PACZone/wrapto/core"
	logger "github.com/PACZone/wrapto/log"
	"github.com/spf13/cobra"
)

func run(cmd *cobra.Command, _ []string) {
	ctx, cancel := context.WithCancel(context.Background())
	c, err := core.NewCore(ctx, cancel)
	kill(cmd, err)

	c.Start()

	<-ctx.Done()
	logger.Info("shutdown")
}

func main() {
	rootCmd := &cobra.Command{
		Use:     "wrapto",
		Version: "",
		Run:     run,
	}

	err := rootCmd.Execute()
	kill(rootCmd, err)
}

func kill(cmd *cobra.Command, err error) {
	if err != nil {
		cmd.PrintErr(err.Error())
		os.Exit(1)
	}
}
