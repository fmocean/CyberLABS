#!/usr/bin/env bash

sudo systemctl status wazuh-manager --no-pager
sudo systemctl status wazuh-indexer --no-pager
sudo systemctl status wazuh-dashboard --no-pager
sudo /var/ossec/bin/agent_control -l
ss -tlnp | grep 443 || true
curl -k https://localhost/status || true
