# ReliefNode 🛰️
### Offline Disaster Relief Registry & Physical Data Mule Mesh Architecture

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new)
[![Antigravity IDE Skill](https://img.shields.io/badge/Antigravity-AgentSkills.io-6366f1.svg)](.agent/skills/relief-mesh/SKILL.md)
[![Flutter Web](https://img.shields.io/badge/Flutter-Web%20Ready-02569B?logo=flutter)](mobile_app/)

> **"What happens when the internet goes down?"**  
> ReliefNode is a zero-infrastructure, offline-first disaster response system. It provides victims with an instant, zero-install emergency intake portal via Raspberry Pi Wi-Fi hubs, while equipping relief workers with a Flutter "Data Mule" app to physically carry and reconcile database records across isolated camps.

---

## ⚡ Dual Static Deployments

The project is architected for dual static deployment under a single root domain:

| Endpoint | Target User | Description | Source |
| :--- | :--- | :--- | :--- |
| **`/`** | **Victims & Citizens** | Emergency Captive Portal with zero-install triage form | [`frontend/index.html`](frontend/index.html) |
| **`/volunteer`** | **Relief Workers** | Data Mule roster inspection & P2P camp-to-camp sync console | [`mobile_app/`](mobile_app/) |

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
│   ├── web/
│   │   ├── index.html            # Flutter Web HTML entrypoint
│   │   └── manifest.json         # PWA Manifest config
│   └── lib/
│       └── main.dart             # Volunteer Data Mule mobile application
├── public/                       # Unified static distribution bundle
│   ├── index.html                # Deployed Victim Portal (Root /)
│   └── volunteer/
│       └── index.html            # Deployed Volunteer App (/volunteer)
├── scripts/
│   ├── build_web.sh              # Unix/CI Flutter web compilation script
│   └── build_web.bat             # Windows Flutter web compilation script
├── docs/
│   ├── ARCHITECTURE.md           # System architecture & CRDT protocol details
│   └── PI_SETUP.md               # Raspberry Pi hostapd + dnsmasq edge runbook
├── .gitignore                    # Git exclusions (Flutter, Dart, Node, OS)
├── vercel.json                   # Zero-config Vercel dual-deployment configuration
└── README.md                     # Project documentation
```

---

## 🚀 Building & Deploying

### 1. Dual Static Build with Flutter Web
Run the automated build script to compile Flutter into the unified `public/` directory:

**Linux / macOS / CI:**
```bash
chmod +x scripts/build_web.sh
./scripts/build_web.sh
```

**Windows:**
```cmd
scripts\build_web.bat
```

**Or compile Flutter directly:**
```bash
cd mobile_app
flutter pub get
flutter build web --release --base-href "/volunteer/"
```

---

### 2. Deploying to Vercel (1-Click)
ReliefNode includes a pre-configured [`vercel.json`](vercel.json) pointing to `/public`:

1. Push this repository to GitHub.
2. Import the repository into your **[Vercel Dashboard](https://vercel.com/new)**.
3. Both the **Victim Portal (`/`)** and **Volunteer App (`/volunteer`)** are deployed instantly.

---

### 3. Local Testing Server
To test both portals locally:

```bash
# Serve static distribution
python -m http.server 8080 --directory public
```
- Open `http://localhost:8080/` for Victim Portal.
- Open `http://localhost:8080/volunteer/` for Volunteer Console.

---

## 🍓 Raspberry Pi Edge Deployment
To flash this onto physical hardware (Raspberry Pi 3/4/Zero 2W) as an autonomous offline hotspot:
- Follow our step-by-step [Raspberry Pi Setup Runbook](docs/PI_SETUP.md).

---

## 📄 License
Distributed under the MIT License.
