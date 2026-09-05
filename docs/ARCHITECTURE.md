# ReliefNode System Architecture

ReliefNode is an offline-first, zero-infrastructure disaster relief registry. It solves the critical bottleneck that occurs when cellular towers, power lines, and internet backbones fail during natural disasters.

---

## 1. System Overview

```
+-------------------------------------------------------------------------+
|                        OFFLINE DISASTER ZONE                            |
|                                                                         |
|   +--------------------------+           +--------------------------+   |
|   |       CAMP ALPHA         |           |        CAMP BRAVO        |   |
|   |  (Raspberry Pi Node A)   |           |  (Raspberry Pi Node B)   |   |
|   |  SSID: RELIEF-MESH-01    |           |  SSID: RELIEF-MESH-02    |   |
|   +------------+-------------+           +-------------+------------+   |
|                ^                                       ^                |
|                |                                       |                |
|       (1) Zero-Install                     (1) Zero-Install             |
|           Victim Intake                        Victim Intake            |
|                |                                       |                |
|     +----------+----------+                 +----------+----------+     |
|     |  Victim Smartphone  |                 |  Victim Smartphone  |     |
|     |  (Captive Portal)   |                 |  (Captive Portal)   |     |
|     +---------------------+                 +---------------------+     |
|                                                                         |
|                ^                                       ^                |
|                |                                       |                |
|                +---------[ (2) DATA MULE TRANSIT ]-----+                |
|                                Volunteer App                            |
|                          - Ingests Node A records                       |
|                          - Travels physically                           |
|                          - Merges with Node B records                   |
+-------------------------------------------------------------------------+
```

---

## 2. Core Subsystems

### Subsystem A: The Edge Node (Captive Portal)
- **Hardware:** Raspberry Pi 3/4/Zero 2W or ESP32-S3.
- **Operating Mode:** Standalone Wi-Fi Access Point (AP).
- **DNS Hijack:** Resolves all DNS queries (e.g. `captive.apple.com`, `connectivitycheck.gstatic.com`) to `192.168.4.1`.
- **Intake Service:** Single lightweight static web payload (`< 50KB`) optimized for low battery consumption and rapid entry under stress.
- **Local Storage:** Append-only JSON ledger / SQLite database stored directly on flash memory.

### Subsystem B: Volunteer Data Mule (Flutter App)
- **Data Carrier:** Emergency workers moving between camps, field hospitals, and evacuation centers.
- **Ingestion:** Auto-discovers and pulls pending registration tickets from Edge Nodes via local HTTP API.
- **Reconciliation Protocol:**
  - **CRDT / Last-Write-Wins (LWW):** Uses deterministic record IDs (`REC-XXXX`) with monotonic timestamps.
  - **Conflict-Free Merging:** Ensures duplicate submissions across camps are idempotently unified without data loss.

---

## 3. Data Schema

```json
{
  "id": "REC-A091",
  "name": "Carlos Rivera",
  "age": 42,
  "bloodType": "O+",
  "status": "Injured",
  "notes": "Laceration on right leg. Needs antiseptic dressing.",
  "originNode": "PI-CAMP-ALPHA-01",
  "registeredAt": "2026-09-05T14:45:00Z",
  "syncedWithCentral": false,
  "version": 1
}
```

---

## 4. Key Advantages
- **Zero App Installation for Victims:** Victims need only Wi-Fi; captive detection handles the rest.
- **Zero Internet Dependency:** Functions entirely in total comms blackout.
- **Asynchronous Eventual Consistency:** Volunteer mules progressively synchronize all camps across the disaster zone.
