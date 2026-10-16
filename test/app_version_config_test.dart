import 'package:flutter_test/flutter_test.dart';
import 'package:wicaraplusapp/app_version_config.dart';

/// Unit tests untuk AppVersionConfig
///
void main() {
  group('AppVersionConfig — tanggal rilis', () {
    test('releaseDate sesuai flavor', () {
      final expected = switch (AppVersionConfig.flavor) {
        AppFlavor.closedBeta => DateTime(2026, 10, 20),
        AppFlavor.publicBeta => DateTime(2026, 11, 3),
        AppFlavor.production => DateTime(2026, 12, 3),
      };

      expect(AppVersionConfig.releaseDate, equals(expected));
    });
  });

  group('AppVersionConfig — isReleaseActive', () {
    test('sehari sebelum rilis → belum aktif', () {
      final dayBefore = AppVersionConfig.releaseDate.subtract(
        const Duration(days: 1),
      );
      expect(AppVersionConfig.isReleaseActive(dayBefore), isFalse);
    });

    test('tepat di hari rilis → aktif', () {
      expect(
        AppVersionConfig.isReleaseActive(AppVersionConfig.releaseDate),
        isTrue,
      );
    });

    test('sehari setelah rilis → aktif', () {
      final dayAfter = AppVersionConfig.releaseDate.add(
        const Duration(days: 1),
      );
      expect(AppVersionConfig.isReleaseActive(dayAfter), isTrue);
    });
  });

  group('AppVersionConfig — label teks', () {
    test('flavorLabel tidak boleh kosong', () {
      expect(AppVersionConfig.flavorLabel, isNotEmpty);
    });

    test('versionCode harus dimulai dengan v', () {
      expect(AppVersionConfig.versionCode, startsWith('v'));
    });

    test('versionCode sesuai flavor', () {
      final expected = switch (AppVersionConfig.flavor) {
        AppFlavor.closedBeta => 'v1.3.1',
        AppFlavor.publicBeta => 'v1.3.2',
        AppFlavor.production => 'v1.3.3',
      };

      expect(AppVersionConfig.versionCode, expected);
    });
  });

  test('productionFreeDays harus 7', () {
    expect(AppVersionConfig.productionFreeDays, 7);
  });
}
