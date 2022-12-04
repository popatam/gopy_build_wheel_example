import simple_go_timer
import time


t = simple_go_timer.NewTimer()
t.Print()
t.Background()
print('python sleeping...')
time.sleep(5)
print('python waking up')
t.Print()
