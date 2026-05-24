# SOC-Range

> *A blue-team lab built to prove monitoring, troubleshooting, detection thinking, and dashboard engineering under real conditions.*

**SOC-Range** is the defensive branch of CyberXI. It is a hands-on Wazuh-centered SOC lab built to show what happens after the install wizard is finished: endpoint onboarding, telemetry validation, Sysmon visibility, alert triage, dashboard design, backend troubleshooting, and the slow transition from default noise to useful signal.

This project is not meant to show “I installed a SIEM once.” It is meant to show that operating a SIEM is a systems problem. The frontend can look healthy while the backend is failing. Agents can be active while producing low-value data. Dashboards can be populated while still telling the analyst nothing useful.

The goal of SOC-Range is to build a small but serious monitoring environment that proves practical skill in:

- Wazuh deployment and stabilization
- Windows and Linux telemetry onboarding
- Sysmon integration
- dashboard design
- alert tuning
- service troubleshooting
- detection engineering direction
- documentation of real failure modes and fixes

---

## Overview

This branch centers on a Wazuh deployment running on Ubuntu with Windows and Linux endpoints enrolled as agents. Wazuh’s dashboard is the web interface used to visualize, analyze, and manage security data, while the Wazuh indexer serves as the search and analytics engine that stores and serves that data for investigation and monitoring.[web:382][web:376]

The project is being shaped like a real SOC environment rather than a one-time lab. That means platform health matters, telemetry quality matters, and dashboard usefulness matters. The focus is not just on “alerts exist,” but on whether those alerts are actionable, visible, and trustworthy.

---

## Lab Environment

| Host | IP | Role |
|------|----|------|
| Wazuh Server | `10.0.0.124` | Ubuntu host running Wazuh manager, indexer, and dashboard |
| Windows 10 Endpoint | `10.0.0.226` | Wazuh agent + Sysmon for endpoint and process visibility |
| Ubuntu Endpoint | `10.0.0.x` | Linux agent for SSH, auth, and sudo telemetry |
| Ubuntu Desktop | `10.0.0.45` | Analyst / operator workstation |

**Hardware**
- Dell R710 homelab server

**Core components**
- Wazuh manager
- Wazuh indexer
- Wazuh dashboard
- Windows Wazuh agent
- Linux Wazuh agent
- Sysmon on Windows
- Grafana direction for richer trend and reporting views

The Wazuh server is built around the manager and Filebeat, with the manager handling analysis and alerting, while the dashboard provides the operational UI for investigating alerts and platform state.

---

## What This Lab Proves

This branch is designed to prove skills that show up repeatedly in SOC Analyst, SOC Engineer, and Security Engineer roles:

- Centralized monitoring across Windows and Linux
- Practical understanding of Wazuh components and dependencies
- Deeper Windows visibility through Sysmon event collection
- Useful dashboarding instead of default visual clutter
- Operational troubleshooting when backend services fail
- Early detection engineering with testing and tuning workflows

The value of the lab is not that it exists. The value is that it documents what was built, what broke, what was fixed, and what the operator learned from the process.

---

## Installation

### Wazuh Server (Ubuntu)

The Wazuh installation guide supports installing the platform components and using the dashboard as the web-based interface for platform visibility and management.

```bash
# Download the all-in-one installer
curl -sO https://packages.wazuh.com/4.x/wazuh-install.sh

# Run the installer
sudo bash wazuh-install.sh -a

# Open core ports
sudo ufw allow 443/tcp
sudo ufw allow 1514/tcp
sudo ufw allow 1515/tcp
sudo ufw allow 55000/tcp

# Verify service status
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard
```

### Windows 10 Agent

Wazuh documents both GUI and CLI installation methods for Windows agents, including setting `WAZUH_MANAGER` during installation and starting the `WazuhSvc` service afterward.

```text
1) Download the Wazuh agent MSI
2) Run the installer as Administrator
3) Enter manager IP: 10.0.0.124
4) Start the agent service
```

CLI-style example:

```powershell
.\wazuh-agent-4.x.x-1.msi /q WAZUH_MANAGER="10.0.0.124"
Start-Service wazuhsvc
```

### Sysmon on Windows

```powershell
.\Sysmon64.exe -accepteula -i .\sysmonconfig-export.xml
```

### Wazuh Agent Sysmon Collection

```xml
<localfile>
  <location>Microsoft-Windows-Sysmon/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

### Restart the Windows Agent

```powershell
Restart-Service WazuhSvc
```

### Linux Agent (Ubuntu Endpoint)

Wazuh supports Linux agent deployment using repository-based installation with `WAZUH_MANAGER` provided during install, followed by enabling and starting the agent service.

```bash
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | \
gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import

sudo chmod 644 /usr/share/keyrings/wazuh.gpg

echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | \
sudo tee /etc/apt/sources.list.d/wazuh.list

sudo apt-get update
sudo WAZUH_MANAGER="10.0.0.124" apt-get install wazuh-agent
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

---

## Configuration Highlights

### Important Ports

```bash
443/tcp   # Wazuh dashboard
1514/tcp  # Agent events
1515/tcp  # Agent enrollment / control
55000/tcp # Wazuh API
```

### Windows Agent Sysmon Block

```xml
<localfile>
  <location>Microsoft-Windows-Sysmon/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

### Common Alert Location

```bash
/var/ossec/logs/alerts/alerts.json
```

### Service Checks

```bash
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard
sudo /var/ossec/bin/agent_control -l
```

The dashboard is used for investigating events, alerts, and platform state, while custom dashboards can be created to visualize the KPIs that matter most for a given environment.

---

## Dashboards

Current dashboard direction is built around practical SOC questions, not vanity metrics:

- Alert volume over time
- Top noisy agents
- Top rules firing
- High and critical alerts only
- Recent alerts with host, severity, rule, and timestamp
- Windows-focused suspicious process activity
- Linux SSH and authentication activity

Wazuh supports custom dashboards for tailoring visualizations to the needs of the environment, which makes it possible to move beyond defaults and build views centered on severity, alert sources, and operational KPIs.

---

## Grafana Direction

Grafana is part of the direction for this branch because it adds another layer of dashboard engineering and presentation maturity. The goal is not to replace Wazuh, but to show that the underlying alert and event data can also be shaped into cleaner time-series views, stronger trend panels, and more executive-friendly reporting.

Planned Grafana-style views:

- Alert rate trends over time
- Severity distribution panels
- Top hosts by alert activity
- Analyst-focused high-priority timeline
- Executive summary dashboards

This matters because employers often care less about one exact UI and more about whether someone can take noisy security telemetry and turn it into useful monitoring surfaces.

---

## Problems Encountered

### 1) “Wazuh dashboard server is not ready yet”

**Symptom**
- The login page or UI shell was reachable.
- The dashboard would not fully load.
- Backend health was not actually good.

**Likely issue**
- `wazuh-indexer` was not fully starting, was timing out, or was otherwise unavailable to the dashboard.

**Troubleshooting used**

```bash
sudo systemctl status wazuh-indexer --no-pager
sudo journalctl -u wazuh-indexer -n 100 --no-pager
sudo systemctl restart wazuh-indexer
sudo systemctl restart wazuh-dashboard
```

This mattered because an open dashboard port does not guarantee that indexed data is available behind the UI. The dashboard depends on the underlying platform components being healthy and connected.

### 2) Dashboard reachable but backend still unhealthy

**Lesson learned**
- A `running` state in systemd does not always mean the platform is usable.
- Service dependency order and backend readiness matter.

**Checks used**

```bash
ss -tlnp | grep 443
curl -k https://localhost/status
sudo systemctl status wazuh-dashboard
```

### 3) Windows config editing problems

**Lesson learned**
- Editing `ossec.conf` under `Program Files` requires elevated privileges.
- On Windows, the editor itself must be launched as Administrator before changes can be saved.

---

## Detection Direction

Default alerts are useful for learning the platform, but the stronger signal for employers is the move toward detection engineering.

Planned or in-progress detection areas:

- PowerShell execution and suspicious command usage
- SSH brute-force attempts
- New local administrator creation
- Persistence through scheduled tasks or Run keys
- Suspicious process relationships
- Basic ATT&CK mapping for detection coverage

The point is to move from “user of alerts” to “builder and tuner of detections.”

---

## Skills Demonstrated

### SOC Analyst Skills

- Understanding endpoint event flow
- Reviewing and triaging alerts
- Identifying noise versus useful signal
- Prioritizing events through dashboards
- Investigating suspicious Windows and Linux activity

### SOC Engineer Skills

- Deploying and stabilizing Wazuh components
- Managing Windows and Linux agents
- Building dashboards around useful KPIs
- Troubleshooting manager / indexer / dashboard dependencies
- Preparing the ground for custom detection logic

### Security Engineer Skills

- Thinking in terms of telemetry quality and coverage
- Extending Windows visibility with Sysmon
- Building an environment that supports investigation
- Converting operational failures into documented improvements
- Presenting technical work as a portfolio artifact

---

## Screenshots

Recommended structure:

```text
images/
├── soc-overview.png
├── top-alerts.png
├── sysmon-events.png
└── wazuh-health.png
```

Example usage in `README.md`:

```md
## Screenshots

### SOC Overview


### Top Alerts


### Sysmon Events


### Wazuh Health

```

GitHub supports relative image paths in README files, which makes storing screenshots inside the repository a clean way to keep documentation portable and self-contained.

---

## Why This Branch Matters

A lot of labs show that a tool was installed. Fewer show that the tool was operated, questioned, improved, and documented under imperfect conditions.

SOC-Range matters because it shows:

- the platform was deployed
- the endpoints were onboarded
- telemetry was improved with Sysmon
- dashboards were shaped around analyst needs
- backend problems were investigated
- detection work is being developed
- the work is documented clearly enough to discuss in interviews

That is what turns a homelab into a portfolio artifact.

---

## Next Steps

- Finalize a stronger SOC overview dashboard
- Add screenshots from Wazuh and future Grafana views
- Add custom rules and documented detections
- Build short incident scenarios and triage notes
- Map detections to MITRE ATT&CK techniques
- Document false positives and tuning decisions

SOC-Range is not meant to stay static. It is being built as a living SOC lab that grows from installation into operations, then from operations into detection engineering.
