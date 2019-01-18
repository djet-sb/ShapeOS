#!/usr/bin/env sh

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
polybar default &
#polybar vga1 &
#polybar vga2 &
#polybar default &

echo "Bars launched..."
