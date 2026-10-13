import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wicaraplusapp/about.dart';
import 'package:wicaraplusapp/app_version_config.dart';
import 'package:wicaraplusapp/e_rapor_page.dart';
import 'package:wicaraplusapp/speech_therapy.dart';
import 'package:wicaraplusapp/play_therapy.dart';
import 'package:wicaraplusapp/splash_screen.dart';
import 'package:wicaraplusapp/paywall_page.dart';
import 'package:wicaraplusapp/login_page.dart';
import 'package:wicaraplusapp/subscription_service.dart';
import 'package:wicaraplusapp/ad_helper.dart';
import 'package:wicaraplusapp/find_expert_page.dart';
import 'firebase_options.dart';

Future<void> _initializeAppServices() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
    rethrow;
  }

  if (!kIsWeb) {
    unawaited(_initializeOptionalServices());
  }
}

Future<void> _initializeOptionalServices() async {
  try {
    await MobileAds.instance.initialize();
  } catch (error, stackTrace) {
    debugPrint('Google Mobile Ads initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    await SubscriptionService().initPlatformState();
  } catch (error, stackTrace) {
    debugPrint('RevenueCat initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initializeServices});

  final Future<void> Function()? initializeServices;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WICARA+ ${AppVersionConfig.flavorLabel}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _AppStartupGate(
        initializeServices: initializeServices ?? _initializeAppServices,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _AppStartupGate extends StatefulWidget {
  const _AppStartupGate({required this.initializeServices});

  final Future<void> Function() initializeServices;

  @override
  State<_AppStartupGate> createState() => _AppStartupGateState();
}

class _AppStartupGateState extends State<_AppStartupGate> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<void> _initialize() => widget.initializeServices();

  void _retryInitialization() {
    setState(() {
      _initialization = _initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aplikasi belum dapat memulai layanan utama. '
                      'Periksa koneksi internet, lalu coba lagi.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _retryInitialization,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const SplashScreen();
      },
    );
  }
}

// ------------------- Home Page -------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  bool _shouldShowAds = false;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      final subscriptionService = SubscriptionService();
      final showAds = await subscriptionService.shouldShowAds();
      if (!mounted) return;
      setState(() {
        _shouldShowAds = showAds;
      });

      if (showAds && !kIsWeb) {
        _loadBannerAd();
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to check subscription status: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget _buildToyButton({
    required String text,
    required Color color,
    required Color shadowColor,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 6),
            blurRadius: 0,
          ),
          const BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: Colors.white),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FF), // Light playful background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.8),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/image/Logo_WICARAplus_trans.png",
                          width: 220,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildToyButton(
                        text: "Terapi Bermain",
                        color: const Color(0xFFFF6B6B), // Coral Red
                        shadowColor: const Color(0xFFC92A2A),
                        icon: Icons.toys_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PlayTherapyPage(),
                            ),
                          );
                        },
                      ),
                      _buildToyButton(
                        text: "Terapi Wicara",
                        color: const Color(0xFF4ECDC4), // Teal
                        shadowColor: const Color(0xFF0CA69E),
                        icon: Icons.record_voice_over_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SpeechTherapyPage(),
                            ),
                          );
                        },
                      ),
                      _buildToyButton(
                        text: "E-Rapor Terapi",
                        color: const Color(0xFF06D6A0),
                        shadowColor: const Color(0xFF059669),
                        icon: Icons.insights_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ERaporPage(),
                            ),
                          );
                        },
                      ),
                      _buildToyButton(
                        text: "Cari Ahli",
                        color: const Color(0xFF3A86FF), // Blue
                        shadowColor: const Color(0xFF2563EB),
                        icon: Icons.person_search_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FindExpertPage(),
                            ),
                          );
                        },
                      ),
                      _buildToyButton(
                        text: "Tentang",
                        color: const Color(0xFFFFD166), // Yellow
                        shadowColor: const Color(0xFFE0A800),
                        icon: Icons.info_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AboutPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildToyButton(
                        text: "Coba Premium",
                        color: const Color(0xFF9D4EDD), // Purple
                        shadowColor: const Color(0xFF5A189A),
                        icon: Icons.workspace_premium_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaywallPage(),
                            ),
                          );
                        },
                      ),
                      _buildToyButton(
                        text: "Keluar",
                        color: const Color(0xFFCED4DA), // Gray
                        shadowColor: const Color(0xFF868E96),
                        icon: Icons.logout_rounded,
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            if (_shouldShowAds && _isBannerAdReady)
              SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}
