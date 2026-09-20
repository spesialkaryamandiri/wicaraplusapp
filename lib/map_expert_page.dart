import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'expert_data.dart';

class MapExpertPage extends StatefulWidget {
  const MapExpertPage({super.key});

  @override
  State<MapExpertPage> createState() => _MapExpertPageState();
}

class _MapExpertPageState extends State<MapExpertPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('partners').get();
      final List<Expert> experts = snapshot.docs.map((doc) {
        return Expert.fromMap(doc.data());
      }).toList();

      final activeExperts = experts.isNotEmpty ? experts : mockExperts;

      if (!mounted) return;
      setState(() {
        _markers.clear();
        for (var expert in activeExperts) {
          _markers.add(
            Marker(
              markerId: MarkerId(expert.name),
              position: LatLng(expert.lat, expert.lng),
              infoWindow: InfoWindow(
                title: expert.name,
                snippet: '${expert.type} - ${expert.phone}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint("Failed to load markers from Firestore: $e");
      if (!mounted) return;
      setState(() {
        _markers.clear();
        for (var expert in mockExperts) {
          _markers.add(
            Marker(
              markerId: MarkerId(expert.name),
              position: LatLng(expert.lat, expert.lng),
              infoWindow: InfoWindow(
                title: expert.name,
                snippet: '${expert.type} - ${expert.phone}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
            ),
          );
        }
      });
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _currentPosition = position;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    }
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
            onPressed: _determinePosition,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-6.2088, 106.8456), // Jakarta
              zoom: 12,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              if (_currentPosition != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    14,
                  ),
                );
              }
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Menampilkan Ahli Terdekat',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Klik marker pada peta untuk melihat detail kontak ahli.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
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
