# CyberXI

> *"To defend a system, you must think like the machine. To break a system, you must think like the adversary. To master both — you must become something the system never anticipated."*

**CyberXI** is a live cybersecurity repository built from two directions at once: blue‑team observability and red‑team pressure. It is not a dump of notes or a shelf of disconnected scripts. It is a working portfolio designed to document real systems, real failure points, and the technical reasoning behind how they are built, monitored, broken, and improved.

The blue side is already active. Endpoints are being monitored, telemetry is being shaped into usable signal, services are being stabilized, and dashboards are being built around analyst needs instead of default noise. The red side is still inbound, but it was part of the architecture from the beginning: adversarial simulation, exploitation logic, privilege paths, persistence, post‑exploitation tradecraft, and detection validation against the same environment the blue side is instrumenting.

This repository exists to make security work visible.

---

## Repository Map

| Branch | Status | Purpose |
| ------ | ------ | ------- |
| [SOC-Range](https://github.com/fmocean/CyberXI/tree/SOC-Range) | Active | Wazuh-based SOC lab with Windows and Linux endpoints, Sysmon, dashboards, alert tuning, troubleshooting, and detection growth |
| [watchdog](https://github.com/fmocean/CyberXI/tree/watchdog) | Active | `net-watch`, a Linux/systemd watchdog for short ghost network drops that standard link-state logging often misses |
| Red Zone | Inbound | Offensive branch planned for recon, exploitation, privilege escalation, persistence, lateral movement, post-exploitation, and validation against blue‑side detections |

These branches already tell the shape of the project: observe the system, harden the system, pressure the system, and document what breaks.

---

## What CyberXI Is

CyberXI is a dual‑discipline security engineering repository that treats offense and defense as two sides of the same technical problem. It does not separate “learning tools” from operational work. Everything here is meant to be testable, explainable, reproducible, and useful under real conditions.

**Core ideas behind the repo:**

- Every observable surface implies an attack surface.  
- Every detection rule implies an evasion path.  
- Every service that claims to be healthy deserves to be tested until that claim breaks.  
- Every trust relationship implies a privilege route waiting to be mapped.  
- Every log source either tells the truth, misses something important, or lies.  

The long‑term goal is convergence: build the environment from the defensive side, then attack that same environment from the offensive side and measure exactly what the stack sees, misses, and misclassifies.

---

## Skills Demonstrated

This repository is designed to show practical ability across security operations, security engineering, Linux administration, troubleshooting, and documentation.

### Blue‑team skills

- Wazuh SIEM/XDR deployment and stabilization  
- Windows and Linux endpoint onboarding  
- Sysmon deployment and Windows event telemetry enrichment  
- Alert triage, dashboard design, and detection tuning  
- Wazuh dashboard, manager, and indexer troubleshooting  
- Journald-based forensic log review  
- Network observability and outage investigation  
- Bash scripting for operational tooling  
- systemd service creation and lifecycle management  
- Grafana‑oriented dashboard thinking for trend analysis and executive reporting  

### Red‑team direction

- Enumeration and attack surface mapping  
- Service fingerprinting and misconfiguration discovery  
- Exploitation chains against real lab targets  
- Linux and Windows privilege escalation paths  
- Persistence mechanics and detection testing  
- Lateral movement simulation across the lab subnet  
- Post‑exploitation tradecraft and evidence review  
- Detection‑gap analysis using MITRE ATT&CK‑style mapping  

---

## SOC-Range

### Overview

[SOC-Range](https://github.com/fmocean/CyberXI/tree/SOC-Range) is the blue‑team branch of CyberXI. It is a Wazuh‑centered SOC lab built to show what happens **after** installation: agent onboarding, telemetry validation, dashboard design, alert quality review, service failures, tuning decisions, and the transition from default visibility to useful visibility.

This branch is meant to demonstrate that operating a SIEM is different from merely deploying one. A frontend can look healthy while the backend is failing. Agents can be active while producing low‑value noise. Dashboards can be full while still answering none of the questions an analyst actually cares about.

### Lab Environment

| Host            | IP           | Role                                                       |
| -------------- | ------------ | ---------------------------------------------------------- |
| Wazuh Server   | `10.0.0.124` | Ubuntu host running Wazuh manager, indexer, and dashboard |
| Windows 10     | `10.0.0.226` | Wazuh agent + Sysmon for process and event visibility     |
| Ubuntu Endpoint| `10.0.0.x`   | Linux telemetry for SSH, auth, and sudo activity          |
| Ubuntu Desktop | `10.0.0.45`  | Analyst / operator workstation                            |

**Hardware in use:**

- Dell R710 homelab server  

### Core Stack

- Wazuh manager  
- Wazuh indexer  
- Wazuh dashboard  
- Windows Wazuh agent  
- Linux Wazuh agent  
- Sysmon on Windows  
- Grafana direction for enhanced trend views and executive‑style reporting  

The Wazuh dashboard provides the web interface for alert review and environment visibility, while the Wazuh indexer stores and serves the analyzed security data that the dashboard queries.

---

### Install Steps

#### Wazuh server (Ubuntu)

```bash
# Download and run the all-in-one installer
curl -sO https://packages.wazuh.com/4.x/wazuh-install.sh
sudo bash wazuh-install.sh -a

# Open core ports
sudo ufw allow 443/tcp
sudo ufw allow 1514/tcp
sudo ufw allow 1515/tcp
sudo ufw allow 55000/tcp

# Verify services
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard
```

#### Windows 10 endpoint

```text
1) Download the Wazuh agent MSI
2) Run the installer as Administrator
3) Enter manager IP: 10.0.0.124
4) Start the agent service
```

#### Sysmon on Windows

```powershell
.\Sysmon64.exe -accepteula -i .\sysmonconfig-export.xml
```

#### Sysmon event collection in Wazuh agent

```xml
<localfile>
  <location>Microsoft-Windows-Sysmon/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

#### Restart the Windows agent

```powershell
Restart-Service WazuhSvc
```

#### Ubuntu endpoint agent

```bash
curl -sO https://packages.wazuh.com/4.x/agents/wazuh-agent.deb
sudo dpkg -i wazuh-agent.deb
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

---

### Config Highlights

#### Useful ports

```bash
443/tcp   # Wazuh dashboard
1514/tcp  # Agent events
1515/tcp  # Agent enrollment / control
55000/tcp # Wazuh API
```

#### Windows agent Sysmon block

```xml
<localfile>
  <location>Microsoft-Windows-Sysmon/Operational</location>
  <log_format>eventchannel</log_format>
</localfile>
```

#### Alert log location

```bash
/var/ossec/logs/alerts/alerts.json
```

---

### Dashboards and Grafana Direction

Current dashboard thinking is built around operational questions instead of vanity numbers:

- Alert volume over time  
- Top noisy agents  
- Top rules firing  
- High and critical alerts only  
- Recent alerts with host, severity, rule, and timestamp  
- Windows‑focused suspicious process activity  
- Linux SSH and authentication patterns  

Wazuh’s dashboard is built to aggregate and visualize security‑related incidents in real time, with the indexer acting as the search and analytics engine underneath that workflow.

Grafana is part of the direction because it signals stronger dashboard engineering skills:

- time‑series panels for alert rate trends  
- cleaner executive reporting views  
- visually stronger analyst dashboards  
- better storytelling for spikes, baselines, and outliers  

---

### Problems Encountered

#### 1) “Wazuh dashboard server is not ready yet”

**Symptom:**

- The UI shell was reachable.  
- The dashboard would not fully load.  
- Backend services were not healthy.  

**Likely issue in the lab:**

- `wazuh-indexer` was not fully starting or timing out during startup.

**Troubleshooting used:**

```bash
sudo systemctl status wazuh-indexer --no-pager
sudo journalctl -u wazuh-indexer -n 100 --no-pager
sudo systemctl restart wazuh-indexer
sudo systemctl restart wazuh-dashboard
```

This mattered because the dashboard depends on indexed data and service health behind the UI, not just the presence of an open web port.

#### 2) Dashboard reachable but backend status unhealthy

**Observed lesson:**

- A “running” service in systemd does not always mean the platform is fully usable.  
- Service dependency and backend initialization order matter.  

**Example checks:**

```bash
ss -tlnp | grep 443
curl -k https://localhost/status
sudo systemctl status wazuh-dashboard
```

#### 3) Windows config editing problems

**Observed lesson:**

- Editing `ossec.conf` under `Program Files` requires elevated privileges.  
- Notepad or another editor needs to be launched as Administrator before saving changes.  

---

### What This Branch Proves

`SOC-Range` is meant to prove:

- SIEM deployment is understood beyond a wizard‑based install  
- Windows and Linux telemetry can be onboarded and validated  
- Sysmon can be used to deepen Windows visibility  
- Alerts can be turned into useful analyst workflows  
- Service health can be troubleshot when the platform breaks  
- Dashboards can be designed around decision‑making, not decoration  

---

## watchdog

### Overview

[watchdog](https://github.com/fmocean/CyberXI/tree/watchdog) contains `net-watch`, a small Linux/systemd‑native watchdog built for one specific problem: the short network drop that kills SSH sessions, stalls downloads, and freezes streams without ever appearing as a clean link‑down event in normal system logs.

Instead of trusting carrier state, `net-watch` trusts reachability. It pings a target once per second and writes only state changes into `journald`: one `LINK DOWN`, one `LINK UP`, and nothing noisy in between.

### Why It Exists

This project exists because some of the most frustrating outages never become obvious evidence:

- SSH freezes  
- Streams buffer  
- Sessions hang  
- Monitoring stays green  
- Link state never drops  

`net-watch` turns that invisible problem into searchable, timestamped evidence.

### Features

- Tiny Bash loop with no external dependencies  
- systemd‑native service design  
- Automatic restart behavior  
- Configurable logger tag  
- Clean `journald` history for flap analysis  
- State‑transition logging instead of per‑ping spam  

### Install

```bash
chmod +x setup-net-watch.sh
sudo ./setup-net-watch.sh
```

The installer is intended to:

- ask for the target to monitor, default `8.8.8.8`  
- ask for the logger tag, default `net_watch`  
- place the script in `/usr/local/bin/net-watch.sh`  
- create `/etc/systemd/system/net-watch.service`  
- reload systemd, enable the service, and start it  

### How It Works

```bash
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
```

### Query Examples

```bash
# All state changes
journalctl -t net_watch

# Drops only
journalctl -t net_watch | grep "LINK DOWN"

# Live view
journalctl -t net_watch -f
```

### What This Branch Proves

The `watchdog` branch is small, but it proves real engineering instincts:

- Linux troubleshooting mindset  
- Bash scripting with operational value  
- systemd service design  
- `journald`‑centric forensic thinking  
- Preference for measuring real behavior instead of trusting weak signals  

---

## Red Zone

> *The offensive branch does not fully exist yet, but the infrastructure built on the blue side was always intended to become the target.*

The red side is not missing by accident. It is being staged behind the blue side for a reason: offensive work becomes more valuable when it is tested against infrastructure that has already been instrumented, logged, and partially hardened.

When the Red Zone branch lands, it is intended to cover:

- passive and active enumeration  
- service fingerprinting  
- exploitation chains against real misconfigurations  
- Linux and Windows privilege escalation  
- persistence techniques such as scheduled tasks, cron, Run keys, and service installation  
- lateral movement across the lab subnet  
- post‑exploitation tradecraft  
- validation of whether Wazuh and future Grafana views actually observed the activity  
- ATT&CK‑style mapping of offensive actions to defensive detections  

The philosophy is simple: the point is not to pop a shell and stop. The point is to run a technique, measure whether the blue side saw it, document the gap, and then improve either the detection or the technique.

---

## Why This Repository Exists

A lot of security portfolios stop at screenshots, completed labs, or lists of tools. This repository exists to go further: build real things, break real things, document what failed, explain why it failed, and improve the design based on evidence.

Each branch is meant to answer technical questions that matter in interviews and code reviews:

- What problem does this solve?  
- What broke during implementation?  
- How was it diagnosed?  
- What changed afterward?  
- Which skills does this prove?  
- Would someone trust this work in a real environment?  

That last question is the point of CyberXI.
