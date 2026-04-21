#!/bin/bash
TARGET=8.8.8.8
TAG=net_watch
STATE=up

while true; do
  if ping -c1 -W1 "$TARGET" >/dev/null 2>&1; then
    if [ "$STATE" = down ]; then
      logger -t "$TAG" "LINK UP to $TARGET"
      STATE=up
    fi
  else
    if [ "$STATE" = up ]; then
      logger -t "$TAG" "LINK DOWN to $TARGET"
      STATE=down
    fi
  fi
  sleep 1
done