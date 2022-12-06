package simple_go_timer

import (
	"context"
	"fmt"
	"os"
	"runtime"
	"time"
)

type TimerInterface interface {
	Reset()
	Stop()
	Print()
	Background()
}

type Timer struct {
	startTime time.Time
	count     int
	ctx       context.Context
	cancel    context.CancelFunc
}

func NewTimer() *Timer {
	ctx, cancel := context.WithCancel(context.Background())
	return &Timer{startTime: time.Now(), count: 0, ctx: ctx, cancel: cancel}
}

func (t *Timer) Reset() {
	t.startTime = time.Now()
	t.count = 0
}

func (t *Timer) Stop() {
	t.cancel()
}

func (t *Timer) Print() {
	t.count += 1
	_, filename, line, _ := runtime.Caller(0)
	fmt.Printf("pid: %v, elapsed: %v, count: %v, where: %v:%v\n", os.Getpid(), time.Since(t.startTime), t.count, filename, line)
}

func (t *Timer) Background() {
	go func() {
		for {
			select {
			case <-t.ctx.Done():
				fmt.Println("stopped")
				return
			default:
				t.Print()
				time.Sleep(time.Second)
			}
		}
	}()
}

func Ping() string {
	return "Pong"
}
