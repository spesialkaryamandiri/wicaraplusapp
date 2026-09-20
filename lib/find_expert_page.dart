import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map_expert_page.dart';
import 'expert_data.dart';

class FindExpertPage extends StatefulWidget {
  const FindExpertPage({super.key});

  @override
  State<FindExpertPage> createState() => _FindExpertPageState();
}

class _FindExpertPageState extends State<FindExpertPage> {
  bool _isServiceAvailable = false;
  String _statusMessage = "Memeriksa status layanan...";

  @override
  void initState() {
    super.initState();
    _checkServiceAvailability();
  }

  void _checkServiceAvailability() {
    final now = DateTime.now();
    // Senin = 1, Minggu = 7
    bool isWorkingDay = now.weekday >= 1 && now.weekday <= 5;
    // Jam kerja: 09:00 - 17:00
    bool isWorkingHour = now.hour >= 9 && now.hour < 17;

    setState(() {
      if (!isWorkingDay) {
        _isServiceAvailable = false;
        _statusMessage = "Layanan offline. Beroperasi pada hari Senin-Jumat.";
      } else if (!isWorkingHour) {
        _isServiceAvailable = false;
        _statusMessage = "Layanan offline. Beroperasi pada jam 09.00 - 17.00 WIB.";
      } else {
        // Untuk hari libur nasional dan cuti bersama, 
        // dalam implementasi nyata bisa dicek ke API kalender nasional.
        _isServiceAvailable = true;
        _statusMessage = "Layanan sedang aktif.";
      }
    });
  }

  void _showNearbyExpertsBottomSheet(BuildContext context, String expertType, Color categoryColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NearbyExpertsBottomSheet(
        expertType: expertType,
        categoryColor: categoryColor,
      ),
    );
  }

  Widget _buildExpertCard(String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          radius: 30,
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(description),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: _isServiceAvailable ? () {
            _showNearbyExpertsBottomSheet(context, title, color);
          } : null,
          child: const Text('Hubungi'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Ahli'),
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isServiceAvailable ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isServiceAvailable ? Colors.green : Colors.red,
                  )
                ),
                child: Row(
                  children: [
                    Icon(
                      _isServiceAvailable ? Icons.check_circle : Icons.error,
                      color: _isServiceAvailable ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "$_statusMessage\n*Kecuali libur nasional & cuti bersama.",
                        style: TextStyle(
                          color: _isServiceAvailable ? Colors.green.shade800 : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapExpertPage()),
                  );
                },
                icon: const Icon(Icons.map),
                label: const Text('Lihat Ahli di Sekitar Saya (Peta)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pilih layanan profesional yang Anda butuhkan:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildExpertCard(
                      "Terapis Wicara",
                      "Membantu anak dengan keterlambatan bicara dan bahasa.",
                      Icons.record_voice_over,
                      const Color(0xFF4ECDC4),
                    ),
                    _buildExpertCard(
                      "Terapis Bermain",
                      "Membantu perkembangan emosi dan sosial anak.",
                      Icons.toys,
                      const Color(0xFFFF6B6B),
                    ),
                    _buildExpertCard(
                      "Psikolog Anak",
                      "Konsultasi untuk masalah perilaku, emosi, & perkembangan.",
                      Icons.psychology,
                      const Color(0xFF9D4EDD),
                    ),
                    _buildExpertCard(
                      "Dokter Spesialis Anak",
                      "Pemeriksaan medis umum dan tumbuh kembang anak.",
                      Icons.medical_services,
                      const Color(0xFFFFD166),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NearbyExpertsBottomSheet extends StatefulWidget {
  final String expertType;
  final Color categoryColor;

  const NearbyExpertsBottomSheet({
    super.key,
    required this.expertType,
    required this.categoryColor,
  });

  @override
  State<NearbyExpertsBottomSheet> createState() => _NearbyExpertsBottomSheetState();
}

class _NearbyExpertsBottomSheetState extends State<NearbyExpertsBottomSheet> {
  Position? _userPosition;
  bool _isLoading = true;
  String? _errorMessage;
  double _selectedRange = 5.0; // Default 5 km
  bool _showAll = false; // Flag to show all

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Layanan GPS di perangkat Anda tidak aktif.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _errorMessage = "Akses lokasi ditolak. Berikan izin lokasi untuk menghitung jarak ahli.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Akses lokasi ditolak secara permanen. Aktifkan lewat pengaturan.";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _userPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "Gagal memuat lokasi: $e";
      });
    }
  }

  double _calculateDistance(double expertLat, double expertLng) {
    if (_userPosition == null) return 0.0;
    final distanceInMeters = Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      expertLat,
      expertLng,
    );
    return distanceInMeters / 1000.0; // return in km
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.only(top: 8),
      height: screenHeight * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          
          // Header title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.categoryColor.withValues(alpha: 0.15),
                  child: Icon(
                    widget.expertType == "Terapis Wicara"
                        ? Icons.record_voice_over
                        : widget.expertType == "Terapis Bermain"
                            ? Icons.toys
                            : widget.expertType == "Psikolog Anak"
                                ? Icons.psychology
                                : Icons.medical_services,
                    color: widget.categoryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.expertType,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        "Daftar Rekomendasi Terdekat",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          const Divider(height: 1),

          // Location state header / filter options
          if (_isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4))),
                    SizedBox(height: 16),
                    Text(
                      "Mencari lokasi Anda saat ini...",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // GPS Location warning or filter chips
            if (_userPosition == null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_off, color: Colors.amber.shade800),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage ?? "Lokasi tidak aktif",
                            style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade800,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _loadLocation,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text("Aktifkan & Cari Ulang Lokasi"),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pilih Radius Pencarian:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRangeChip(2.0, "2 km"),
                        _buildRangeChip(5.0, "5 km"),
                        _buildRangeChip(10.0, "10 km"),
                        _buildRangeChip(double.infinity, "Semua", isAll: true),
                      ],
                    ),
                  ],
                ),
              ),

            // Expert list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('partners')
                    .where('specialty', isEqualTo: widget.expertType)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<Expert> typeExperts = [];
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    typeExperts = snapshot.data!.docs.map((doc) {
                      return Expert.fromMap(doc.data() as Map<String, dynamic>);
                    }).toList();
                  }

                  // Fallback to mockExperts if database is empty for this type
                  if (typeExperts.isEmpty) {
                    typeExperts = mockExperts.where((e) => e.type == widget.expertType).toList();
                  }

                  // Map each expert to their details and distance
                  List<Map<String, dynamic>> expertsWithDistance = typeExperts.map((expert) {
                    double distance = 0.0;
                    if (_userPosition != null) {
                      distance = _calculateDistance(expert.lat, expert.lng);
                    }
                    return {
                      'expert': expert,
                      'distance': distance,
                    };
                  }).toList();

                  // Filter by distance if location is available and we are not showing 'Semua'
                  if (_userPosition != null && !_showAll) {
                    expertsWithDistance = expertsWithDistance.where((e) => e['distance'] <= _selectedRange).toList();
                  }

                  // Sort by distance if location is available
                  if (_userPosition != null) {
                    expertsWithDistance.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
                  } else {
                    expertsWithDistance.sort((a, b) => (a['expert'] as Expert).name.compareTo((b['expert'] as Expert).name));
                  }

                  if (expertsWithDistance.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            "Tidak ada ahli dalam radius ${_showAll ? 'Semua' : '${_selectedRange.toInt()} km'}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Coba perluas radius pencarian Anda.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: expertsWithDistance.length,
                    itemBuilder: (context, index) {
                      final data = expertsWithDistance[index];
                      final Expert expert = data['expert'];
                      final double distance = data['distance'];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.grey.shade100,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          expert.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 14, color: widget.categoryColor),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                expert.address,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (_userPosition != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: widget.categoryColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "${distance.toStringAsFixed(1)} km",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: widget.categoryColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      _showContactOptions(context, expert);
                                    },
                                    icon: const Icon(Icons.phone, size: 16),
                                    label: const Text("Hubungi"),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: widget.categoryColor,
                                      side: BorderSide(color: widget.categoryColor),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRangeChip(double range, String label, {bool isAll = false}) {
    final bool isSelected = isAll ? _showAll : (!_showAll && _selectedRange == range);

    return ChoiceChip(
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      selected: isSelected,
      selectedColor: widget.categoryColor,
      backgroundColor: Colors.grey.shade100,
      elevation: isSelected ? 2 : 0,
      pressElevation: 4,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            if (isAll) {
              _showAll = true;
            } else {
              _showAll = false;
              _selectedRange = range;
            }
          });
        }
      },
    );
  }

  void _showContactOptions(BuildContext context, Expert expert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Hubungi ${expert.name}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Pilih jalur komunikasi untuk berkonsultasi dengan ${expert.name}:",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.chat, color: Colors.green),
                ),
                title: const Text("WhatsApp"),
                subtitle: Text(expert.phone),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Mengalihkan ke chat WhatsApp ${expert.name}..."),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.phone, color: Colors.blue),
                ),
                title: const Text("Telepon Seluler"),
                subtitle: Text(expert.phone),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Melakukan panggilan ke ${expert.name}..."),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
