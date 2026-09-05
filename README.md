# ReliefNode 🛰️
### Offline Disaster Relief Registry & Physical Data Mule Mesh Architecture

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new)
[![Antigravity IDE Skill](https://img.shields.io/badge/Antigravity-AgentSkills.io-6366f1.svg)](.agent/skills/relief-mesh/SKILL.md)
[![Flutter](https://img.shields.io/badge/Flutter-v3.0+-02569B?logo=flutter)](mobile_app/)

> **"What happens when the internet goes down?"**  
> ReliefNode is a zero-infrastructure, offline-first disaster response system. It provides victims with an instant, zero-install emergency intake portal via Raspberry Pi Wi-Fi hubs, while equipping relief workers with a Flutter "Data Mule" app to physically carry and reconcile database records across isolated camps.

---

## ⚡ Key Architectural Features

1. **Zero-Install Intake (Victims)**
   - No app download or internet connection required.
   - Victims connect to the local node's Wi-Fi (`EMERGENCY-RELIEF-MESH`) and are automatically redirected to the emergency captive portal.
   - Captures triage status (Safe / Injured / Missing), blood type, age, and critical medical notes.

2. **Physical Data Mule Mesh (Volunteers)**
   - When towers are down, human mobility becomes the transmission layer.
   - Relief workers running the **ReliefNode Flutter App** harvest encrypted records from local nodes.
   - As volunteers travel between camps, the app reconciles datasets using Conflict-Free Replicated Data Types (CRDT / Last-Write-Wins) to ensure zero data loss.

3. **Agentskills.io Integration**
   - Packaged with an official Antigravity IDE skill specification ([`SKILL.md`](.agent/skills/relief-mesh/SKILL.md)) for autonomous agent orchestration, edge provisioning, and simulated network testing.

---

## 🏗️ Repository Structure

```text
ReliefNode/
├── .agent/
│   └── skills/
│       └── relief-mesh/
│           └── SKILL.md          # Antigravity IDE Agent Skill Spec
├── frontend/
│   └── index.html                # Zero-install Captive Portal web interface
├── mobile_app/
│   ├── pubspec.yaml              # Flutter dependencies & metadata
│   ├── analysis_options.yaml     # Dart lint rules
│   └── lib/
│       └── main.dart             # Volunteer Data Mule mobile application
├── docs/
│   ├── ARCHITECTURE.md           # System architecture & CRDT protocol details
│   └── PI_SETUP.md               # Raspberry Pi hostapd + dnsmasq edge runbook
├── .gitignore                    # Git exclusions (Flutter, Dart, Node, OS)
├── vercel.json                   # Zero-config Vercel static deployment
└── README.md                     # Project documentation
```

---

## 🚀 Quick Start

### 1. Running the Captive Portal Locally
Simply open [`frontend/index.html`](frontend/index.html) in any modern browser:

```bash
# Optional: Serve locally with python or any static server
python -m http.server 8080 --directory frontend
```
Navigate to `http://localhost:8080` to experience the mobile-responsive victim intake interface.

---

### 2. Running the Volunteer Data Mule Mobile App
Ensure you have Flutter installed ([Flutter Install Guide](https://docs.flutter.dev/get-started/install)):

```bash
cd mobile_app
flutter pub get
flutter run
```

---

## 🌐 Deploying to Vercel

ReliefNode is pre-configured with [`vercel.json`](vercel.json) for instant static deployment:

1. Push this repository to GitHub.
2. Import the repository into your **[Vercel Dashboard](https://vercel.com/new)**.
3. Vercel will automatically detect the static frontend and deploy your live demo.

---

## 🍓 Deploying to Raspberry Pi (Hardware Node)

To deploy the Captive Portal on physical edge hardware (Raspberry Pi 3/4/Zero 2W):
- Follow our step-by-step [Raspberry Pi Setup Runbook](docs/PI_SETUP.md) to configure `hostapd`, `dnsmasq` DNS hijacking, and Nginx captive redirection.

---

## 🛠️ Technology Stack

| Layer | Technology | Purpose |
| :--- | :--- | :--- |
| **Edge Portal** | Vanilla HTML5 / Modern CSS / ES6 JS | Zero-dependency `< 50KB` captive intake page |
| **Volunteer App** | Flutter / Dart | Offline state management & Data Mule sync simulator |
| **Edge Hardware** | Raspberry Pi / ESP32 | Offline Wi-Fi Access Point & Local SQLite/JSON store |
| **Spec Engine** | Antigravity IDE (`agentskills.io`) | Autonomous agent instruction and relief mesh runbook |

---

## 📄 License
Distributed under the MIT License. See `LICENSE` for more information.
