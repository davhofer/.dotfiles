#!/bin/bash

# Count connected bluetooth devices
count=$(bluetoothctl devices Connected | wc -l)

# Output formatted string with icon
if [ "$count" -gt 0 ]; then
  echo "󰂯 $count"
else
  echo "󰂯"
fi
