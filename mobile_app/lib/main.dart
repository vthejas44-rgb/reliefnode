import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ReliefNodeVolunteerApp());
}

class VictimRecord {
  final String id;
  final String name;
  final int age;
  final String bloodType;
  final String status; // 'Safe', 'Injured', 'Missing'
  final String notes;
  final String originNode;
  final DateTime registeredAt;
  final bool syncedWithCentral;

  VictimRecord({
    required this.id,
    required this.name,
    required this.age,
    required this.bloodType,
    required this.status,
    required this.notes,
    required this.originNode,
    required this.registeredAt,
    this.syncedWithCentral = false,
  });

  VictimRecord copyWith({
    String? id,
    String? name,
    int? age,
    String? bloodType,
    String? status,
    String? notes,
    String? originNode,
    DateTime? registeredAt,
    bool? syncedWithCentral,
  }) {
    return VictimRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      bloodType: bloodType ?? this.bloodType,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      originNode: originNode ?? this.originNode,
      registeredAt: registeredAt ?? this.registeredAt,
      syncedWithCentral: syncedWithCentral ?? this.syncedWithCentral,
    );
  }
}

class ReliefNodeVolunteerApp extends StatelessWidget {
  const ReliefNodeVolunteerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReliefNode Data Mule',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F141C),
        primaryColor: const Color(0xFFDC2626),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFDC2626),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1A2230),
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF1A2230),
          elevation: 2,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF141B26),
          elevation: 0,
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // Local Roster State (Simulating Device Local DB)
  final List<VictimRecord> _roster = [
    VictimRecord(
      id: 'REC-A091',
      name: 'Carlos Rivera',
      age: 42,
      bloodType: 'O+',
      status: 'Injured',
      notes: 'Laceration on right leg. Needs antiseptic dressing.',
      originNode: 'PI-CAMP-ALPHA-01',
      registeredAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    VictimRecord(
      id: 'REC-A092',
      name: 'Elena Rostova',
      age: 29,
      bloodType: 'A+',
      status: 'Safe',
      notes: 'Sheltered with 2 children at Sector 3 tent.',
      originNode: 'PI-CAMP-ALPHA-01',
      registeredAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    VictimRecord(
      id: 'REC-A093',
      name: 'Marcus Chen',
      age: 68,
      bloodType: 'B-',
      status: 'Missing',
      notes: 'Last seen near West Bridge riverbank.',
      originNode: 'PI-CAMP-ALPHA-01',
      registeredAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  // Sync Activity Log State
  final List<String> _syncLogs = [
    '[SYSTEM] Local SQLite DB initialized. Ready for offline transport.',
    '[PORTAL] Loaded 3 cached records from local flash memory.',
  ];

  bool _isSyncing = false;

  void _addLog(String msg) {
    setState(() {
      _syncLogs.insert(0, '[${DateTime.now().toIso8601String().substring(11, 19)}] $msg');
    });
  }

  // Simulation: Connect to Local Pi Captive Portal & Harvest Data
  Future<void> _harvestFromLocalPi() async {
    setState(() => _isSyncing = true);
    _addLog('Scanning for "EMERGENCY-RELIEF-MESH" Wi-Fi SSID...');
    
    await Future.delayed(const Duration(milliseconds: 700));
    _addLog('Connected to Pi Gateway: 192.168.4.1:8080');
    
    await Future.delayed(const Duration(milliseconds: 800));
    final newVictim = VictimRecord(
      id: 'REC-A09${_roster.length + 1}',
      name: 'Priya Sharma (${_roster.length + 1})',
      age: 31,
      bloodType: 'AB+',
      status: 'Safe',
      notes: 'Walk-in registration via Captive Portal hotspot.',
      originNode: 'PI-CAMP-ALPHA-01',
      registeredAt: DateTime.now(),
    );

    setState(() {
      _roster.insert(0, newVictim);
      _isSyncing = false;
    });

    _addLog('SUCCESS: Ingested 1 new record [${newVictim.id}] from Camp Alpha Pi.');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harvested new victim data from Local Pi [${newVictim.id}]'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  // Simulation: Data Mule Transfer - Sync with Camp B and reconcile datasets
  Future<void> _syncWithCampB() async {
    setState(() => _isSyncing = true);
    _addLog('Initiating Data Mule handshake with Camp B Node (10.0.8.1)...');

    await Future.delayed(const Duration(milliseconds: 800));
    _addLog('Exchanging Merkle hash set with Camp B...');

    await Future.delayed(const Duration(milliseconds: 900));

    // Simulated Camp B records
    final campBRecords = [
      VictimRecord(
        id: 'REC-B201',
        name: 'David Kim',
        age: 51,
        bloodType: 'O-',
        status: 'Injured',
        notes: 'Needs asthma inhaler replacement.',
        originNode: 'PI-CAMP-BRAVO-02',
        registeredAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      VictimRecord(
        id: 'REC-B202',
        name: 'Amina Al-Mansoor',
        age: 19,
        bloodType: 'A-',
        status: 'Safe',
        notes: 'Separated from group in Valley sector.',
        originNode: 'PI-CAMP-BRAVO-02',
        registeredAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    int addedCount = 0;
    for (var r in campBRecords) {
      if (!_roster.any((existing) => existing.id == r.id)) {
        _roster.add(r);
        addedCount++;
      }
    }

    setState(() => _isSyncing = false);
    _addLog('SYNC COMPLETE: Reconciled $addedCount foreign records from Camp Bravo.');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mule Sync Complete! Merged $addedCount records from Camp B.'),
          backgroundColor: const Color(0xFF3B82F6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          CampRosterView(roster: _roster),
          DataMuleSyncView(
            rosterCount: _roster.length,
            isSyncing: _isSyncing,
            logs: _syncLogs,
            onHarvestLocalPi: _harvestFromLocalPi,
            onSyncCampB: _syncWithCampB,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF263345), width: 1)),
        ),
        child: NavigationBar(
          backgroundColor: const Color(0xFF141B26),
          indicatorColor: const Color(0xFFDC2626).withOpacity(0.2),
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.people_alt_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.people_alt, color: Color(0xFFF87171)),
              label: 'Camp Roster',
            ),
            NavigationDestination(
              icon: Icon(Icons.sync_alt_outlined, color: Colors.grey),
              selectedIcon: Icon(Icons.sync_alt, color: Color(0xFFF87171)),
              label: 'Data Mule Sync',
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1. CAMP ROSTER VIEW
// ==========================================
class CampRosterView extends StatefulWidget {
  final List<VictimRecord> roster;
  const CampRosterView({super.key, required this.roster});

  @override
  State<CampRosterView> createState() => _CampRosterViewState();
}

class _CampRosterViewState extends State<CampRosterView> {
  String _searchQuery = '';
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.roster.where((r) {
      final matchesSearch = r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.notes.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.id.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == 'All' || r.status == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.emergency, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text(
              'CAMP ROSTER',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1, fontSize: 16),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF263345),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.sd_storage, size: 14, color: Color(0xFF10B981)),
                const SizedBox(width: 4),
                Text(
                  '${widget.roster.length} Cached',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF141B26),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search victims by name, condition, or ID...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                    filled: true,
                    fillColor: const Color(0xFF0F141C),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF263345)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF263345)),
                    ),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Safe', 'Injured', 'Missing'].map((status) {
                      final isSelected = _filterStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          selectedColor: const Color(0xFFDC2626),
                          backgroundColor: const Color(0xFF1E2633),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) => setState(() => _filterStatus = status),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // List View
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No matching records in offline storage.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      Color statusColor;
                      IconData statusIcon;

                      switch (item.status) {
                        case 'Safe':
                          statusColor = const Color(0xFF10B981);
                          statusIcon = Icons.check_circle_outline;
                          break;
                        case 'Injured':
                          statusColor = const Color(0xFFEF4444);
                          statusIcon = Icons.warning_amber_rounded;
                          break;
                        default:
                          statusColor = const Color(0xFFF59E0B);
                          statusIcon = Icons.help_outline;
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: statusColor.withOpacity(0.3), width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F141C),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.id,
                                      style: const TextStyle(
                                        color: Color(0xFFF87171),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${item.name}, ${item.age}y',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(statusIcon, size: 12, color: statusColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.status,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.notes,
                                style: const TextStyle(
                                  color: Color(0xFFCBD5E1),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '🩸 Blood: ${item.bloodType}',
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '📍 ${item.originNode}',
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. DATA MULE NETWORK & SYNC CONSOLE
// ==========================================
class DataMuleSyncView extends StatelessWidget {
  final int rosterCount;
  final bool isSyncing;
  final List<String> logs;
  final VoidCallback onHarvestLocalPi;
  final VoidCallback onSyncCampB;

  const DataMuleSyncView({
    super.key,
    required this.rosterCount,
    required this.isSyncing,
    required this.logs,
    required this.onHarvestLocalPi,
    required this.onSyncCampB,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DATA MULE CONSOLE',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'RELIEF MESH PROTOCOL',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ZERO-INTERNET MODE',
                          style: TextStyle(color: Color(0xFFF87171), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const Divider(height: 20, color: Color(0xFF334155)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _metricBox('LOCAL RECORDS', '$rosterCount', Icons.storage),
                      _metricBox('ACTIVE NODES', '2 Camps', Icons.hub),
                      _metricBox('SYNC HEALTH', '100% OK', Icons.verified),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Simulation Action Buttons
            const Text(
              'PHYSICAL DATA MULE ACTIONS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: isSyncing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.wifi_tethering),
              label: Text(
                isSyncing ? 'Connecting to Pi...' : 'Connect to Local Pi (Ingest Hotspot Records)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              onPressed: isSyncing ? null : onHarvestLocalPi,
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: isSyncing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.sync_alt),
              label: Text(
                isSyncing ? 'Reconciling Datasets...' : 'Act as Data Mule: Sync with Camp B',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              onPressed: isSyncing ? null : onSyncCampB,
            ),

            const SizedBox(height: 16),

            // Activity / Handshake Terminal
            const Text(
              'TRANSMISSION ACTIVITY LOG',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1),
            ),
            const SizedBox(height: 6),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0E14),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, idx) {
                    final log = logs[idx];
                    final isSuccess = log.contains('SUCCESS') || log.contains('COMPLETE');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        log,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: isSuccess ? const Color(0xFF4ADE80) : const Color(0xFF94A3B8),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricBox(String title, String val, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(height: 4),
        Text(
          val,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 9, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
