# SOC Engineering Range

file:///home/ocean/Pictures/Screenshots/Screenshot%20from%202026-05-24%2009-32-55.png

Builds:
endpoint onboarding, SIEM operations, alert triage, dashboard design, detection tuning, troubleshooting, and security engineering under imperfect conditions.

This project is centred on Wazuh, Windows, Linux, Sysmon, and dashboarding with a Grafana-style analyst mindset.
Wazuh already supports custom dashboards and visualizations for alert review and investigation.
Grafana can also be used with Wazuh data through the OpenSearch or Elasticsearch-style backend path that users commonly wire up for more flexible operational views.[cite:255][cite:256][cite:303]

This is not a screenshot repo.
This is not “installed a SIEM once.”
This is a working SOC lab built to prove practical skill.

---

## 

A good security lab should make it obvious what the builder can do.
This one is designed to prove capability in the areas that show up over and over in SOC Analyst, SOC Engineer, and Cybersecurity Engineer job descriptions.

It demonstrates:

- Bringing Windows and Linux endpoints under centralized monitoring.
- Working with Wazuh agents, manager, indexer, and dashboard components.[cite:42][cite:58]
- Improving Windows visibility with Sysmon event collection through the Wazuh agent.[cite:7][cite:10][cite:29]
- Turning raw event flow into dashboards that support triage instead of noise.[cite:256][cite:273]
- Investigating service failures such as the classic `Wazuh dashboard server is not ready yet` condition caused by indexer startup problems.[cite:284][cite:285][cite:295]
- Building the foundation for custom detection engineering with Wazuh rules and `wazuh-logtest`.[cite:234][cite:237][cite:240]

That combination matters because employers do not just want people who can click around in a dashboard.
They want people who understand where the data comes from, why alerts fire, what breaks the platform, and how to make visibility useful.[cite:227][cite:228][cite:236]

---

## Lab story

The lab began as a basic Wazuh deployment on a Dell R710 homelab with Ubuntu and Windows virtual machines.
It quickly turned into something more useful: a small SOC environment where telemetry, alerts, dashboards, and platform health all matter at the same time.

That shift is important.
Installing Wazuh is easy compared with making it useful.
A real SOC workflow starts when the platform has to answer actual questions:

- Which endpoint is noisy?
- What rules are firing most?
- Are the alerts low-value noise or something worth triaging?
- Is the dashboard healthy, or is the backend dying underneath it?
- Can suspicious Windows behaviour be seen clearly enough to investigate?

This repository exists to answer those questions in a way that is visible to recruiters, hiring managers, and technical interviewers.

---

## Current environment

Current working environment:

- Wazuh server: `10.0.0.124`
- Windows 10 endpoint: `10.0.0.226`
- Ubuntu endpoint(s): used for Linux telemetry and SSH-related scenarios
- Ubuntu desktop: used as the analyst/operator workstation

Core components in play:

- Wazuh manager
- Wazuh indexer
- Wazuh dashboard
- Windows Wazuh agent
- Linux Wazuh agent(s)
- Sysmon on Windows

Wazuh uses the dashboard for visualization and the `wazuh-alerts-*` pattern for alert-based analysis, while custom dashboard work is built around those indexed alerts.[cite:255][cite:256][cite:271]

---

## Why Grafana matters here

The point of adding a Grafana mindset is not to replace Wazuh just for the sake of it.
It is to show that the same data can be shaped into stronger operational views, executive views, and engineering views.

Grafana is valuable in this project because it signals a few things immediately:

- Comfort with data sources, queries, and panel design.
- Ability to build dashboards for different audiences.
- Understanding of trends, baselines, spikes, and outliers instead of static counts.
- Ability to present security data in a way that looks mature and professional.

Wazuh users commonly connect Grafana to the OpenSearch/Elasticsearch-style backend to visualize Wazuh data, and Grafana Labs publishes community dashboards specifically for Wazuh SIEM/XDR and MITRE ATT&CK views.[cite:303][cite:302][cite:308]

That matters for job hunting because many employers care less about one exact UI and more about whether someone can take security telemetry and build a usable monitoring surface from it.

---

## What a strong dashboard should show

A weak dashboard shows numbers.
A strong dashboard answers questions.

This project is being shaped around dashboards that tell an analyst what matters right now:

- Alert volume over time
- Top noisy agents
- Top rules firing
- High and critical alerts only
- Recent alerts with timestamp, host, severity, and rule description
- Windows-specific suspicious process activity
- SSH-focused views for Linux authentication events

Wazuh custom dashboard guidance emphasizes defining KPIs first, then building visualizations around alert severity, active/disconnected agents, source-specific monitoring, and data tables for high-priority events.[cite:273][cite:256]

Grafana makes that idea even more powerful because it is excellent for trend panels, time-series views, drilldowns, and clean layout.
Community Grafana dashboards for Wazuh include SIEM/XDR overviews, MITRE ATT&CK views, and compliance-focused dashboards, which makes it a strong add-on for presenting both technical and executive-friendly reporting.[cite:302][cite:308][cite:311]

---

## Skills this project is meant to signal

### SOC analyst skills

- Understanding endpoint event flow
- Reading and interpreting security alerts
- Recognizing noisy vs meaningful activity
- Using dashboards to prioritize triage
- Investigating suspicious authentication and process activity

### SOC engineer skills

- Deploying and stabilizing Wazuh components
- Managing agent onboarding across Windows and Linux
- Building dashboards around useful KPIs instead of default views
- Troubleshooting indexer/dashboard dependencies
- Preparing custom rules and field-based searches

### Security engineer skills

- Thinking in terms of telemetry quality and detection coverage
- Extending visibility with Sysmon
- Designing an environment that supports investigation and detection validation
- Converting operational problems into documented improvements
- Building a portfolio project around real engineering decisions, not just screenshots

---

## Detection direction

Default alerts are useful for learning the platform, but custom detections are what turn this lab into a serious project.

Planned or in-progress detections include:

- PowerShell execution and suspicious command usage on Windows
- SSH brute-force attempts on Linux
- New local administrator creation
- Persistence behavior through scheduled tasks or Run keys
- Suspicious process relationships

Wazuh’s own threat-hunting and rule-testing guidance supports this workflow: identify useful behaviors, build rules around them, test them with `wazuh-logtest`, and tune them until the signal is useful.[cite:234][cite:237][cite:240]

That workflow is one of the biggest job signals in the whole repo because it shows movement from “user of tools” to “builder of detections.”

---

## Operational lessons learned

One of the best things about this project is that it has already produced real troubleshooting experience.
The lab ran into the classic Wazuh situation where the UI was reachable but the backend was not healthy, leading to the message `Wazuh dashboard server is not ready yet` when the indexer failed or timed out during startup.[cite:284][cite:285][cite:286]

That is not wasted time.
That is actual platform operations work.

Handling that issue teaches several things employers care about:

- Security tooling depends on service health, not just configuration.
- Dashboards can lie if the backend is broken.
- Startup order and timeout tuning matter.
- A reliable SOC stack is part of the job, not somebody else’s problem.

Wazuh community guidance for these timeout cases includes increasing `TimeoutStartSec`, checking indexer logs, and tuning the environment so the indexer has enough time and resources to initialize.[cite:291][cite:295][cite:296]
