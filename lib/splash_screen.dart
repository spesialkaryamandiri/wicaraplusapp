import 'package:flutter/material.dart';
import 'package:wicaraplusapp/app_version_config.dart';
import 'package:wicaraplusapp/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final bool _isActive = AppVersionConfig.isReleaseActive();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

    if (_isActive) {
      // Fase sudah aktif → lanjut ke halaman utama setelah 3 detik
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      });
    }
    // Jika belum aktif, tetap di halaman splash (tampilkan countdown)
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ─── Warna badge per flavor ────────────────────────────────────────────────
  Color get _flavorColor {
    switch (AppVersionConfig.flavor) {
      case AppFlavor.closedBeta:
        return const Color(0xFF7B2D8B); // ungu tua
      case AppFlavor.publicBeta:
        return const Color(0xFF1976D2); // biru
      case AppFlavor.production:
        return const Color(0xFF2E7D32); // hijau
    }
  }

  Color get _flavorTextColor => Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo ──────────────────────────────────────────────────────
              Image.asset(
                'assets/image/LogoWICARAplus.jpg',
                width: 200,
                errorBuilder: (context, error, _) =>
                    const Icon(Icons.flash_on, size: 100, color: Colors.blue),
              ),
              const SizedBox(height: 16),

              // ── Badge Flavor ──────────────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _flavorColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${AppVersionConfig.flavorLabel}  •  ${AppVersionConfig.versionCode}',
                  style: TextStyle(
                    color: _flavorTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Status / Countdown ────────────────────────────────────────
              if (!_isActive) ...[
                _buildComingSoonCard(),
              ] else ...[
                // Pesan singkat saat sudah aktif
                if (AppVersionConfig.accessStatusMessage().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      AppVersionConfig.accessStatusMessage(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black54),
                    ),
                  ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComingSoonCard() {
    final releaseDate = AppVersionConfig.releaseDate;
    final daysLeft = releaseDate.difference(DateTime.now()).inDays + 1;
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final releaseDateStr =
        '${releaseDate.day} ${months[releaseDate.month]} ${releaseDate.year}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _flavorColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _flavorColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.schedule_rounded, size: 48, color: _flavorColor),
          const SizedBox(height: 12),
          Text(
            'Segera Hadir',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _flavorColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppVersionConfig.flavorLabel} akan aktif pada:',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            releaseDateStr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _flavorColor,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _flavorColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '$daysLeft hari lagi',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
