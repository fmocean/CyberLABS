🔍 net-watch
Tiny, always‑on network drop watchdog for Linux + systemd.

net-watch solves the most annoying kind of outage: the 2–5 second ghost drop that kills SSH sessions and streams but never shows up as “link down” anywhere. Instead of trusting your NIC driver or NetworkManager to notice, net-watch just pings and writes the truth into journald.

Why?
You know the drill:

SSH freezes.

Streams buffer.

Monitoring graphs show… nothing.

If the physical link never loses carrier, your system logs often stay clean. net-watch doesn’t care about link state; it cares about reachability.

It:

Pings a target once per second.

Emits LINK DOWN / LINK UP on state changes only.

Logs everything to the systemd journal under a tag you choose (default: net_watch).

Searchable, timestamped, no BS.

Features
🧠 Brain‑dead simple: small Bash loop, no dependencies.

🧷 Systemd‑native: runs as a service, restarts automatically.

🏷️ Taggable: pick your own log tag (net_watch, net_watch_gw, etc.).

🕵️ Forensic‑friendly: query flaps with one journalctl line.

Install (plug & play)
One‑shot setup:

bash
chmod +x setup-net-watch.sh
sudo ./setup-net-watch.sh
The installer will:

Ask you for:

Target to monitor (default: 8.8.8.8)

Logger tag (default: net_watch)

Drop the watchdog at:

/usr/local/bin/net-watch.sh

Create a systemd unit at:

/etc/systemd/system/net-watch.service

Reload systemd, enable, and start the service.

Check that it’s alive:

bash
systemctl status net-watch.service
How it works
Generated (simplified) watcher:

bash
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
First failed ping after “up” → one LINK DOWN.

First successful ping after “down” → one LINK UP.

Everything goes into the systemd journal with your tag.

No spammy per‑ping logs, just state transitions.