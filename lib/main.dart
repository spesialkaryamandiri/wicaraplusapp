import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wicaraplusapp/about.dart';
import 'package:wicaraplusapp/app_version_config.dart';
import 'package:wicaraplusapp/speech_therapy.dart';
import 'package:wicaraplusapp/play_therapy.dart';
import 'package:wicaraplusapp/splash_screen.dart';
import 'package:wicaraplusapp/paywall_page.dart';
import 'package:wicaraplusapp/login_page.dart';
import 'package:wicaraplusapp/subscription_service.dart';
import 'package:wicaraplusapp/ad_helper.dart';
import 'package:wicaraplusapp/find_expert_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  
  MobileAds.instance.initialize();
  
  // Inisialisasi RevenueCat
  await SubscriptionService().initPlatformState();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WICARA+ ${AppVersionConfig.flavorLabel}',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
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
    final subscriptionService = SubscriptionService();
    final showAds = await subscriptionService.shouldShowAds();
    setState(() {
      _shouldShowAds = showAds;
    });

    if (_shouldShowAds) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
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
                        child: Image.asset("assets/image/Logo_WICARAplus_trans.png", width: 220),
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
                            MaterialPageRoute(builder: (_) => const PlayTherapyPage()),
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
                            MaterialPageRoute(builder: (_) => const SpeechTherapyPage()),
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
                            MaterialPageRoute(builder: (_) => const FindExpertPage()),
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
                            MaterialPageRoute(builder: (_) => const AboutPage()),
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
                            MaterialPageRoute(builder: (_) => const PaywallPage()),
                          );
                        },
                      ),
                      _buildToyButton(
                        text: "Keluar",
                        color: const Color(0xFFCED4DA), // Gray
                        shadowColor: const Color(0xFF868E96),
                        icon: Icons.logout_rounded,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
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
