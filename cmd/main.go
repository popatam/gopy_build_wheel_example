package main

import (
	"context"
	"simple_go_timer"
	"time"
)

const timeout = 5 * time.Second

func main() {
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	t := simple_go_timer.NewTimer()
	t.Print()
	go t.Background()
	<-ctx.Done()
	cancel()
}
