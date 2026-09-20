class Expert {
  final String name;
  final String type; // e.g., 'Terapis Wicara', 'Terapis Bermain', 'Psikolog Anak', 'Dokter Spesialis Anak'
  final double lat;
  final double lng;
  final String phone;
  final String address;

  const Expert({
    required this.name,
    required this.type,
    required this.lat,
    required this.lng,
    required this.phone,
    required this.address,
  });

  factory Expert.fromMap(Map<String, dynamic> map) {
    return Expert(
      name: map['fullName'] ?? '',
      type: map['specialty'] ?? '',
      lat: (map['latitude'] as num?)?.toDouble() ?? -6.2088,
      lng: (map['longitude'] as num?)?.toDouble() ?? 106.8456,
      phone: map['phone'] ?? '',
      address: map['location'] ?? '',
    );
  }
}

const List<Expert> mockExperts = [
  Expert(
    name: 'Klinik Tumbuh Kembang A',
    type: 'Terapis Wicara',
    lat: -6.2088,
    lng: 106.8456,
    phone: '08123456789',
    address: 'Jl. Jend. Sudirman Kav. 21, Karet Semanggi, Jakarta Pusat',
  ),
  Expert(
    name: 'Terapis Wicara Mitra Utama',
    type: 'Terapis Wicara',
    lat: -6.2200,
    lng: 106.8350,
    phone: '08129999888',
    address: 'Jl. Gatot Subroto No. 45, Kuningan Barat, Mampang Prapatan, Jakarta Selatan',
  ),
  Expert(
    name: 'Klinik Wicara Mandiri',
    type: 'Terapis Wicara',
    lat: -6.2500,
    lng: 106.8200,
    phone: '08127777666',
    address: 'Jl. Kemang Raya No. 8, Bangka, Mampang Prapatan, Jakarta Selatan',
  ),
  Expert(
    name: 'Pusat Terapi Bermain D',
    type: 'Terapis Bermain',
    lat: -6.2200,
    lng: 106.8600,
    phone: '08111222333',
    address: 'Jl. Tebet Barat Raya No. 3, Tebet Barat, Tebet, Jakarta Selatan',
  ),
  Expert(
    name: 'Terapis Bermain Ceria',
    type: 'Terapis Bermain',
    lat: -6.1800,
    lng: 106.8100,
    phone: '08112233445',
    address: 'Jl. Tanah Abang II No. 15, Petojo Selatan, Gambir, Jakarta Pusat',
  ),
  Expert(
    name: 'Psikolog Anak B',
    type: 'Psikolog Anak',
    lat: -6.2146,
    lng: 106.8451,
    phone: '08987654321',
    address: 'Jl. H. R. Rasuna Said Kav. X-2 No. 5, Kuningan Timur, Setiabudi, Jakarta Selatan',
  ),
  Expert(
    name: 'Psikolog Tumbuh Kembang E',
    type: 'Psikolog Anak',
    lat: -6.1500,
    lng: 106.8500,
    phone: '08981111222',
    address: 'Jl. Cempaka Putih Raya No. 5, Cempaka Putih Timur, Cempaka Putih, Jakarta Pusat',
  ),
  Expert(
    name: 'RS Spesialis Anak C',
    type: 'Dokter Spesialis Anak',
    lat: -6.2000,
    lng: 106.8300,
    phone: '08555666777',
    address: 'Jl. Pangeran Diponegoro No. 71, Kenari, Senen, Jakarta Pusat',
  ),
  Expert(
    name: 'Klinik Anak Sehat F',
    type: 'Dokter Spesialis Anak',
    lat: -6.2800,
    lng: 106.8000,
    phone: '08554444333',
    address: 'Jl. RS. Fatmawati Raya No. 88, Cilandak Barat, Cilandak, Jakarta Selatan',
  ),
];
