#!/usr/bin/env bash

sudo systemctl status wazuh-indexer --no-pager
sudo journalctl -u wazuh-indexer -n 100 --no-pager
sudo systemctl restart wazuh-indexer
sudo systemctl restart wazuh-dashboard
