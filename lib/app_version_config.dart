library;

/// AppVersionConfig
///
/// Digunakan untuk mengontrol perilaku aplikasi berdasarkan flavor build.
/// Setiap flavor dikompilasi menggunakan `--dart-define=APP_FLAVOR=nilai`.
///
/// - closedBeta  → Ujicoba Tertutup   (aktif mulai 12 Maret 2026)
/// - publicBeta  → Ujicoba Publik     (aktif mulai 30 Maret 2026)
/// - production  → Rilis Resmi        (aktif mulai 11 April 2026, semua fitur
///                                     premium gratis 7 hari sejak rilis)

const String _kFlavor = String.fromEnvironment('APP_FLAVOR', defaultValue: 'production');

class AppVersionConfig {
  AppVersionConfig._();

  // ─── Flavor ───────────────────────────────────────────────────────────────

  static AppFlavor get flavor {
    switch (_kFlavor) {
      case 'closedBeta':
        return AppFlavor.closedBeta;
      case 'publicBeta':
        return AppFlavor.publicBeta;
      default:
        return AppFlavor.production;
    }
  }

  // ─── Tanggal Aktif per Flavor ─────────────────────────────────────────────

  static DateTime get releaseDate {
    switch (flavor) {
      case AppFlavor.closedBeta:
        return DateTime(2026, 3, 12); // 12 Maret 2026
      case AppFlavor.publicBeta:
        return DateTime(2026, 3, 30); // 30 Maret 2026
      case AppFlavor.production:
        return DateTime(2026, 4, 11); // 11 April 2026
    }
  }

  /// Lamanya fitur premium gratis untuk flavor production (7 hari).
  static const int productionFreeDays = 7;

  // ─── Label Teks ───────────────────────────────────────────────────────────

  static String get flavorLabel {
    switch (flavor) {
      case AppFlavor.closedBeta:
        return 'Ujicoba Tertutup';
      case AppFlavor.publicBeta:
        return 'Ujicoba Publik';
      case AppFlavor.production:
        return 'Rilis Resmi';
    }
  }

  static String get versionCode {
    switch (flavor) {
      case AppFlavor.closedBeta:
        return 'v0.9.0';
      case AppFlavor.publicBeta:
        return 'v0.9.5';
      case AppFlavor.production:
        return 'v1.2.5';
    }
  }

  // ─── Logika Akses ─────────────────────────────────────────────────────────

  /// Apakah fase rilis saat ini sudah aktif (tanggal sekarang ≥ releaseDate)?
  static bool isReleaseActive() {
    return true; // Bypass countdown
  }

  /// Untuk ujicoba tertutup & publik: semua fitur terbuka selama fase aktif.
  static bool allFeaturesUnlockedForBeta() {
    return (flavor == AppFlavor.closedBeta || flavor == AppFlavor.publicBeta) &&
        isReleaseActive();
  }

  /// Untuk production: cek apakah masih dalam periode 7 hari gratis premium
  /// sejak tanggal rilis (11 April – 17 April 2026).
  static bool isProductionFreePeriodActive() {
    if (flavor != AppFlavor.production) return false;
    if (!isReleaseActive()) return false;
    final now = DateTime.now();
    final difference = now.difference(releaseDate).inDays;
    return difference >= 0 && difference < productionFreeDays;
  }

  /// Apakah pengguna mendapat akses penuh ke semua konten TANPA perlu
  /// berlangganan? (beta aktif ATAU production trial aktif)
  static bool hasAutoFullAccess() {
    return allFeaturesUnlockedForBeta() || isProductionFreePeriodActive();
  }

  /// Sisa hari dalam periode gratis production (0 jika sudah habis/bukan production).
  static int productionFreeDaysRemaining() {
    if (flavor != AppFlavor.production || !isReleaseActive()) return 0;
    final now = DateTime.now();
    final elapsed = now.difference(releaseDate).inDays;
    final remaining = productionFreeDays - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  /// Pesan informatif untuk ditampilkan di splash/home berdasarkan status.
  static String accessStatusMessage() {
    if (!isReleaseActive()) {
      final daysLeft = releaseDate.difference(DateTime.now()).inDays + 1;
      return 'Aplikasi akan aktif dalam $daysLeft hari lagi\n(${_formatDate(releaseDate)})';
    }
    if (flavor == AppFlavor.closedBeta) {
      return 'Ujicoba Tertutup Aktif — Semua fitur terbuka';
    }
    if (flavor == AppFlavor.publicBeta) {
      return 'Ujicoba Publik Aktif — Semua fitur terbuka';
    }
    // production
    final remaining = productionFreeDaysRemaining();
    if (remaining > 0) {
      return 'Selamat! Nikmati semua fitur Premium gratis\nselama $remaining hari lagi 🎉';
    }
    return '';
  }

  static String _formatDate(DateTime d) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }
}

enum AppFlavor {
  closedBeta,
  publicBeta,
  production,
}
