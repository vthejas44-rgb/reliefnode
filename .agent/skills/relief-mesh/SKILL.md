---
name: relief-mesh
description: >-
  Use this skill to build, configure, and maintain an offline disaster relief mesh architecture.
  Teaches the agent how to implement zero-install Captive Portal web interfaces for victim intake
  on edge devices (Raspberry Pi/ESP32) and engineer offline-first Flutter Data Mule mobile applications
  with local JSON conflict-free replication and peer-to-peer camp-to-camp sync.
---

# Relief Mesh: Offline Disaster Architecture & Data Mule System

This skill provides architectural patterns, implementation runbooks, and interface designs for zero-connectivity disaster response environments.

```text
               +----------------------------------------------------+
               |           OFFLINE LOCAL RELIEF NODE                |
               |             (Raspberry Pi / ESP32)                 |
               |                                                    |
               |  [Wi-Fi AP: "EMERGENCY-RELIEF-MESH"]               |
               |  [DNS Hijack / Captive Portal Engine]              |
               |  [Local SQLite / JSON Append-Only Log: /api/roster]|
               +-------------------------+--------------------------+
                                         ^
              (1) Victim Self-Report     |     (2) Data Mule Harvest
                  via Captive Portal     |         via Local HTTP Sync
                                         |
     +-----------------------------------+-----------------------------------+
     |                                                                       |
+----+--------------------+                                    +-------------+-------------+
|    VICTIM SMARTPHONE    |                                    |     VOLUNTEER FLUTTER     |
| (Zero-Install Browser)  |                                    |       DATA MULE APP       |
|                         |                                    |                           |
| - Captive network popup |                                    | - Harvests Node A Roster  |
| - Form: Triage & Needs  |                                    | - Transports physically   |
| - Submits to Local Node |                                    | - Merges with Camp B Node |
+-------------------------+                                    +---------------------------+
```

---

## 1. Captive Portal Architecture (Edge / Raspberry Pi)

### 1.1 Core Principles
- **Zero External Dependencies:** No external CDNs, fonts, or tracking scripts. All CSS and JavaScript must be embedded in a single lightweight payload (`< 50KB`).
- **Universal Captive Trigger:** The local HTTP daemon (e.g., `dnsmasq` + `nginx` or Python lightweight server) must intercept captive probe requests:
  - Android: `generate_204`, `gen_204`
  - iOS/macOS: `hotspot-detect.html`, `captive.apple.com`
  - Windows: `connecttest.txt`, `ncsi.txt`
- **Triage & Emergency Aesthetics:**
  - High-visibility palette: Safety Red (`#D32F2F`), Alert Amber (`#F57C00`), High-Contrast Charcoal (`#121212`), Crisp White (`#FFFFFF`).
  - Clear, large touch targets (min `48px` height) for stressed individuals on small screens.
  - Offline local caching via `localStorage` with queue status so victims know their report is saved even if Wi-Fi glitches.

### 1.2 Data Schema (JSON Victim Record)
```json
{
  "id": "uuid-v4-or-timestamp-hash",
  "name": "Jane Doe",
  "age": 34,
  "bloodType": "O+",
  "status": "Injured",
  "medicalNotes": "Fractured left wrist, needs splint",
  "contactInfo": "Family at West Shelter",
  "registeredAt": "2026-09-05T14:30:00Z",
  "nodeId": "PI-CAMP-ALPHA-01",
  "syncVersion": 1
}
```

---

## 2. Volunteer Flutter App (Data Mule Architecture)

### 2.1 Data Mule Synchronization Protocol
In total communications blackouts, volunteer relief workers act as physical "Data Mules", carrying data across isolated relief zones.

1. **Phase 1: Ingestion (Local Node Extraction):**
   - Flutter app connects to local Pi Wi-Fi access point (`192.168.4.1:8080`).
   - Fetches pending JSON victim records via `GET /api/v1/roster`.
   - Stores locally in device storage (`sqflite` or encrypted JSON file).

2. **Phase 2: Physical Transit:**
   - Volunteer travels across zones/camps (zero network required during transit).
   - Local UI allows search, triage filtering, and marking volunteer actions.

3. **Phase 3: Union & Reconciliation (Camp-to-Camp Sync):**
   - Volunteer connects to Camp B's local Pi or peers with another volunteer's app.
   - Executes Last-Write-Wins (LWW) or Merkle-set union merging on `id` and `registeredAt` timestamps.
   - Pushes delta updates to prevent data loss.

### 2.2 Flutter State & UI Guidelines
- **Theme:** High-contrast rugged dark mode (`#0D1117` surface, `#238636` sync green, `#F85149` triage red, `#E3B341` warning yellow).
- **Navigation:**
  - **Camp Roster:** Live searchable list with status badges, blood type tags, and timestamp indicators.
  - **Data Mule Sync Console:** Diagnostic monitor showing active node connection, cached payload size, last sync timestamp, and manual simulation triggers.
