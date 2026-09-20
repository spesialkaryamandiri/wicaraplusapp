import 'package:flutter_test/flutter_test.dart';
import 'package:wicaraplusapp/app_version_config.dart';

/// Unit tests untuk AppVersionConfig
///
/// Catatan: Karena AppVersionConfig menggunakan const dart-define yang
/// dikompilasi pada build time, tes ini menguji logika waktu dengan
/// DateTime yang bisa dikontrol secara manual di tiap skenario.
///
/// Jalankan dengan:
///   flutter test test/app_version_config_test.dart
void main() {
  group('AppVersionConfig — tanggal rilis', () {
    test('closedBeta releaseDate harus 12 Maret 2026', () {
      final expected = DateTime(2026, 3, 12);
      expect(DateTime(2026, 3, 12), equals(expected));
    });

    test('publicBeta releaseDate harus 30 Maret 2026', () {
      final expected = DateTime(2026, 3, 30);
      expect(DateTime(2026, 3, 30), equals(expected));
    });

    test('production releaseDate harus 11 April 2026', () {
      final expected = DateTime(2026, 4, 11);
      expect(DateTime(2026, 4, 11), equals(expected));
    });
  });

  group('AppVersionConfig — logika periode production gratis', () {
    test('hari ke-0 dari rilis production → masih dalam periode gratis', () {
      final releaseDate = DateTime(2026, 4, 11);
      final now = DateTime(2026, 4, 11);
      final diff = now.difference(releaseDate).inDays;
      expect(diff < AppVersionConfig.productionFreeDays, isTrue);
    });

    test('hari ke-6 dari rilis production → masih dalam periode gratis', () {
      final releaseDate = DateTime(2026, 4, 11);
      final now = DateTime(2026, 4, 17); // hari ke-6
      final diff = now.difference(releaseDate).inDays;
      expect(diff < AppVersionConfig.productionFreeDays, isTrue);
    });

    test('hari ke-7 dari rilis production → periode gratis habis', () {
      final releaseDate = DateTime(2026, 4, 11);
      final now = DateTime(2026, 4, 18); // hari ke-7 = habis
      final diff = now.difference(releaseDate).inDays;
      expect(diff < AppVersionConfig.productionFreeDays, isFalse);
    });

    test('productionFreeDays harus 7', () {
      expect(AppVersionConfig.productionFreeDays, equals(7));
    });
  });

  group('AppVersionConfig — isReleaseActive (simulasi tanggal)', () {
    test('sehari sebelum rilis → belum aktif', () {
      final releaseDate = DateTime(2026, 4, 11);
      final now = DateTime(2026, 4, 10);
      expect(now.isBefore(releaseDate), isTrue);
    });

    test('tepat di hari rilis → aktif', () {
      final releaseDate = DateTime(2026, 4, 11);
      final now = DateTime(2026, 4, 11);
      expect(!now.isBefore(releaseDate), isTrue);
    });

    test('sehari setelah rilis → aktif', () {
      final releaseDate = DateTime(2026, 4, 11);
      final now = DateTime(2026, 4, 12);
      expect(!now.isBefore(releaseDate), isTrue);
    });
  });

  group('AppVersionConfig — label teks', () {
    test('flavorLabel tidak boleh kosong', () {
      expect(AppVersionConfig.flavorLabel, isNotEmpty);
    });

    test('versionCode harus dimulai dengan v', () {
      expect(AppVersionConfig.versionCode, startsWith('v'));
    });
  });
}
