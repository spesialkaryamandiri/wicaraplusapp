import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'expert_data.dart';

class MapExpertPage extends StatefulWidget {
  const MapExpertPage({super.key});

  @override
  State<MapExpertPage> createState() => _MapExpertPageState();
}

class _MapExpertPageState extends State<MapExpertPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _hasLocationPermission = false;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('partners')
          .get();
      final List<Expert> experts = snapshot.docs.map((doc) {
        return Expert.fromMap(doc.data());
      }).toList();

      final activeExperts = experts.isNotEmpty ? experts : mockExperts;

      if (!mounted) return;
      _updateMarkers(activeExperts);
    } catch (e) {
      debugPrint("Failed to load markers from Firestore: $e");
      if (!mounted) return;
      _updateMarkers(mockExperts);
    }
  }

  void _updateMarkers(List<Expert> experts) {
    setState(() {
      _markers.clear();
      for (var expert in experts) {
        _markers.add(
          Marker(
            markerId: MarkerId(expert.name),
            position: LatLng(expert.lat, expert.lng),
            infoWindow: InfoWindow(
              title: expert.name,
              snippet: '${expert.type} - Klik untuk opsi & rute',
              onTap: () => _showExpertBottomSheet(expert),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueCyan,
            ),
            onTap: () => _showExpertBottomSheet(expert),
          ),
        );
      }
    });
  }

  Future<void> _determinePosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationMessage(
          'Aktifkan layanan lokasi untuk melihat posisi Anda.',
        );
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showLocationMessage(
          'Izin lokasi ditolak. Peta tetap dapat digunakan.',
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Izin lokasi dinonaktifkan. Ubah izinnya melalui pengaturan perangkat/browser.',
        );
        return;
      }

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showLocationMessage(
          'Izin lokasi belum tersedia. Peta tetap dapat digunakan.',
        );
        return;
      }

      if (!mounted) return;
      setState(() {
        _hasLocationPermission = true;
      });

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _currentPosition = position;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to determine device location: $error');
      debugPrintStack(stackTrace: stackTrace);
      _showLocationMessage(
        'Lokasi tidak dapat diperoleh. Peta tetap dapat digunakan.',
      );
    }
  }

  void _showLocationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _cleanPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '62${cleaned.substring(1)}';
    }
    return cleaned;
  }

  Future<void> _openGoogleMapsRoute(Expert expert) async {
    final Uri mapUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${expert.lat},${expert.lng}',
    );
    try {
      if (await canLaunchUrl(mapUri)) {
        await launchUrl(mapUri, mode: LaunchMode.externalApplication);
      } else {
        _showLocationMessage('Tidak dapat membuka Google Maps');
      }
    } catch (e) {
      debugPrint("Error opening Google Maps: $e");
    }
  }

  Future<void> _openWhatsApp(Expert expert) async {
    final cleaned = _cleanPhoneNumber(expert.phone);
    final text = Uri.encodeComponent(
      'Halo ${expert.name}, saya ingin konsultasi terapi melalui WICARA+.',
    );
    final Uri waUri = Uri.parse('https://wa.me/$cleaned?text=$text');
    try {
      if (await canLaunchUrl(waUri)) {
        await launchUrl(waUri, mode: LaunchMode.externalApplication);
      } else {
        _showLocationMessage('Tidak dapat membuka WhatsApp');
      }
    } catch (e) {
      debugPrint("Error opening WhatsApp: $e");
    }
  }

  Future<void> _openPhone(Expert expert) async {
    final Uri phoneUri = Uri.parse('tel:${expert.phone}');
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showLocationMessage('Tidak dapat melakukan panggilan telepon');
      }
    } catch (e) {
      debugPrint("Error dialing phone: $e");
    }
  }

  void _showExpertBottomSheet(Expert expert) {
    double? distanceKm;
    if (_currentPosition != null) {
      final meters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        expert.lat,
        expert.lng,
      );
      distanceKm = meters / 1000.0;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF4ECDC4).withValues(alpha: 0.15),
                    radius: 26,
                    child: const Icon(Icons.person_pin_circle, color: Color(0xFF4ECDC4), size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expert.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          expert.type,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4ECDC4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (distanceKm != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ECDC4).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${distanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4ECDC4),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      expert.address,
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4ECDC4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _openGoogleMapsRoute(expert);
                      },
                      icon: const Icon(Icons.directions, size: 20),
                      label: const Text('Rute Google Maps'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _openWhatsApp(expert);
                    },
                    icon: const Icon(Icons.chat),
                    tooltip: 'WhatsApp',
                  ),
                  const SizedBox(width: 6),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _openPhone(expert);
                    },
                    icon: const Icon(Icons.phone),
                    tooltip: 'Telepon',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Ahli Terdekat'),
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Posisi Saya',
            onPressed: _determinePosition,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-6.2088, 106.8456), // Jakarta default
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              final position = _currentPosition;
              if (position != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(position.latitude, position.longitude),
                    14,
                  ),
                );
              }
            },
            markers: _markers,
            myLocationEnabled: _hasLocationPermission,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.map, color: Color(0xFF4ECDC4), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_markers.length} Terapis & Klinik Terdaftar',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            'Klik pin untuk rute Google Maps & kontak langsung',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
