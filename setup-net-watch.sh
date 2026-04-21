#!/bin/bash
# setup-net-watch.sh
# One-shot installer for net-watch.sh + systemd service

set -e

SCRIPT_PATH="/usr/local/bin/net-watch.sh"
SERVICE_PATH="/etc/systemd/system/net-watch.service"

echo "=== Net Watchdog Setup ==="

# Ask for target and tag
read -rp "Target to monitor (default: 8.8.8.8): " TARGET
TARGET=${TARGET:-8.8.8.8}

read -rp "Logger tag (default: net_watch): " TAG
TAG=${TAG:-net_watch}

echo
echo "Using:"
echo "  Target : $TARGET"
echo "  Tag    : $TAG"
echo

# Create watchdog script
echo "Creating $SCRIPT_PATH ..."
cat <<EOF | sudo tee "$SCRIPT_PATH" >/dev/null
#!/bin/bash
TARGET=${TARGET}
TAG=${TAG}
STATE=up

while true; do
  if ping -c1 -W1 "\$TARGET" >/dev/null 2>&1; then
    if [ "\$STATE" = down ]; then
      logger -t "\$TAG" "LINK UP to \$TARGET"
      STATE=up
    fi
  else
    if [ "\$STATE" = up ]; then
      logger -t "\$TAG" "LINK DOWN to \$TARGET"
      STATE=down
    fi
  fi
  sleep 1
done
EOF

sudo chmod +x "$SCRIPT_PATH"
echo "Script created and made executable."

# Create systemd service
echo "Creating $SERVICE_PATH ..."
cat <<EOF | sudo tee "$SERVICE_PATH" >/dev/null
[Unit]
Description=Simple network connectivity watcher (\$TARGET)
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=$SCRIPT_PATH
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd, enabling and starting service ..."
sudo systemctl daemon-reload
sudo systemctl enable --now net-watch.service

echo
echo "=== Done ==="
echo "Check status with:"
echo "  systemctl status net-watch.service"
echo
echo "View logs with:"
echo "  journalctl -t $TAG --since \"today\""