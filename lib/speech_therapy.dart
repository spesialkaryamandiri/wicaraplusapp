import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_player/video_player.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:wicaraplusapp/app_version_config.dart';
import 'package:wicaraplusapp/speech_therapy_data.dart';
import 'package:wicaraplusapp/subscription_service.dart';
import 'package:wicaraplusapp/ad_helper.dart';

class SpeechTherapyPage extends StatefulWidget {
  const SpeechTherapyPage({super.key});

  @override
  _SpeechTherapyPageState createState() => _SpeechTherapyPageState();
}

class _SpeechTherapyPageState extends State<SpeechTherapyPage> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _hasAccess = false;
  bool _autoUnlock = false; // true saat beta aktif atau production free period
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final access = await _subscriptionService.canAccessAllContent();
    if (!mounted) return;
    setState(() {
      _hasAccess = access;
      _autoUnlock = AppVersionConfig.hasAutoFullAccess();
    });

    if (!_hasAccess && !_autoUnlock && !kIsWeb) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terapi Wicara"),
        actions: [
          if (_autoUnlock)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                label: Text(
                  AppVersionConfig.flavorLabel,
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
                backgroundColor: Colors.green.shade600,
                padding: EdgeInsets.zero,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tampilkan banner trial/beli hanya jika tidak ada auto-unlock
              if (!_autoUnlock && !_hasAccess)
                _buildTrialBanner(),
              // Tampilkan banner info untuk production free period
              if (_autoUnlock)
                _buildAutoBanner(),
              // Iklan hanya tampil jika tidak punya akses sama sekali
              if (!_hasAccess && !_autoUnlock && _isBannerAdReady)
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  height: _bannerAd!.size.height.toDouble(),
                  width: _bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              const SizedBox(height: 20),
              _buildCategoryGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAutoBanner() {
    final msg = AppVersionConfig.accessStatusMessage();
    if (msg.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppVersionConfig.flavor == AppFlavor.production
              ? [Colors.green.shade400, Colors.teal.shade400]
              : [Colors.purple.shade400, Colors.blue.shade400],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrialBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        children: [
          const Text(
            "Coba Fitur Lengkap Gratis Selama 7 Hari!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await _subscriptionService.startTrial();
              await _checkStatus();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Masa percobaan 7 hari dimulai!")),
                );
              }
            },
            child: const Text("Mulai Uji Coba Gratis"),
          ),
          const SizedBox(height: 5),
          TextButton(
             onPressed: () async {
                // Simulasi pembayaran
                await _subscriptionService.setPremiumLocal(true);
                await _checkStatus();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Anda telah berlangganan Premium!")),
                  );
                }
             },
             child: const Text("Langganan Rp119.000/bln"),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: speechTherapyData.length,
      itemBuilder: (context, index) {
        final category = speechTherapyData[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(TherapyCategory category) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryDetailPage(
              category: category,
              isPremiumCallback: () => _subscriptionService.canAccessAllContent(),
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.record_voice_over, size: 50, color: Colors.blue), // Placeholder icon
             // Image.asset(category.iconPath, height: 60), // Use actual asset if available
            const SizedBox(height: 10),
            Text(
              category.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDetailPage extends StatefulWidget {
  final TherapyCategory category;
  final Future<bool> Function() isPremiumCallback;

  const CategoryDetailPage({super.key, required this.category, required this.isPremiumCallback});

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
    bool hasAccess = false;

    @override
    void initState() {
        super.initState();
        widget.isPremiumCallback().then((value) {
            if (!mounted) return;
            setState(() {
                hasAccess = value;
            });
        });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.category.items.length,
        itemBuilder: (context, index) {
          final item = widget.category.items[index];
          final isLocked = !item.isFree && !hasAccess;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(isLocked ? Icons.lock : Icons.play_circle_fill, color: isLocked ? Colors.grey : Colors.green),
              title: Text(item.title, style: TextStyle(color: isLocked ? Colors.grey : Colors.black)),
              trailing: isLocked ? const Text("Premium Only", style: TextStyle(color: Colors.red, fontSize: 12)) : null,
              onTap: isLocked
                  ? () {
                     ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text("Upgrade ke Premium untuk membuka konten ini!")),
                     );
                  }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExercisePage(item: item),
                        ),
                      );
                    },
            ),
          );
        },
      ),
    );
  }
}

class ExercisePage extends StatefulWidget {
  final TherapyItem item;

  const ExercisePage({super.key, required this.item});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late VideoPlayerController _videoController;
  String? feedbackMessage; // Feedback message ("Benar!" / "Salah!")
  Color feedbackColor = Colors.transparent;

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = "";

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initSpeech();
    // Set orientasi menjadi horizontal (landscape) saat masuk ke halaman ini
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // Initialize video player (Assuming assets exist, handle errors otherwise)
    _videoController = VideoPlayerController.asset(widget.item.videoPath)
      ..initialize().then((_) {
        if (mounted) setState(() {});
      }).catchError((error) {
          debugPrint("Error loading video: $error");
      });
  }

  void _initSpeech() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (errorNotification) {
        if (mounted) setState(() => _isListening = false);
      },
    );
    if (!available) {
      debugPrint("Speech recognition not available");
    }
  }

  void _startListening() async {
    if (!_speechToText.isAvailable) {
       ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Fitur Speech-to-Text tidak tersedia di perangkat ini."))
       );
       return;
    }
    
    setState(() {
      _recognizedText = "";
      feedbackMessage = null;
    });

    await _speechToText.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _recognizedText = result.recognizedWords;
            if (result.finalResult) {
              _checkSpokenAnswer(_recognizedText);
            }
          });
        }
      },
      localeId: 'id_ID', // Bahasa Indonesia
    );
    
    if (mounted) setState(() => _isListening = true);
  }

  void _stopListening() async {
    await _speechToText.stop();
    if (mounted) setState(() => _isListening = false);
  }

  void _checkSpokenAnswer(String text) {
     final targetTitle = widget.item.title.toLowerCase();
     final spoken = text.toLowerCase();
     
     if (spoken.contains(targetTitle) || targetTitle.contains(spoken)) {
        _checkAnswer(true);
     } else {
        _checkAnswer(false);
     }
  }

  @override
  void dispose() {
    // Kembalikan orientasi ke portrait (vertikal) saat keluar dari halaman ini
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _checkAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        feedbackMessage = "Ya!";
        feedbackColor = Colors.green;
        _audioPlayer.play(AssetSource('audio/Hasil_Ya.mp3'));
      } else {
        feedbackMessage = "Tidak!";
        feedbackColor = Colors.red;
        _audioPlayer.play(AssetSource('audio/Hasil_Tidak.mp3'));
      }

      // Clear feedback after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
              setState(() {
                  feedbackMessage = null;
                  feedbackColor = Colors.transparent;
              });
          }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Latihan: ${widget.item.title}")),
      body: SingleChildScrollView(
         child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // Kiri: Video
                    Expanded(
                        flex: 1,
                        child: Column(
                            children: [
                                Container(
                                    height: 200,
                                    decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                                    child: _videoController.value.isInitialized
                                        ? AspectRatio(
                                            aspectRatio: _videoController.value.aspectRatio,
                                            child: VideoPlayer(_videoController),
                                          )
                                        : const Center(child: Icon(Icons.videocam_off, size: 50, color: Colors.grey)), 
                                ),
                                const SizedBox(height: 10),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                         IconButton(
                                            icon: Icon(_videoController.value.isPlaying ? Icons.pause : Icons.play_arrow),
                                            onPressed: () {
                                                setState(() {
                                                    if (_videoController.value.isPlaying) {
                                                        _videoController.pause();
                                                    } else {
                                                        _videoController.play();
                                                    }
                                                });
                                            },
                                        ),
                                        const Text("Putar Video"),
                                    ],
                                ),
                            ],
                        ),
                    ),
                    const SizedBox(width: 16),
                    // Tengah: Gambar Contoh Visual Benda
                    Expanded(
                        flex: 1,
                        child: Column(
                            children: [
                                Image.asset(
                                    widget.item.imagePath, 
                                    height: 200,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    "Contoh Visual", 
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700])
                                ),
                            ],
                        ),
                    ),
                    const SizedBox(width: 16),
                    // Kanan: Tombol Rekam & Hasil
                    Expanded(
                        flex: 1,
                        child: Column(
                            children: [
                                ElevatedButton.icon(
                                    onPressed: _isListening ? _stopListening : _startListening,
                                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                                    label: Text(_isListening ? "Berhenti Merekam" : "Mulai Rekam"),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 48),
                                        backgroundColor: _isListening ? Colors.red : Colors.blue,
                                        foregroundColor: Colors.white,
                                    ),
                                ),
                                if (_recognizedText.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Terdengar: $_recognizedText",
                                      style: const TextStyle(fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                const SizedBox(height: 30),

                                const SizedBox(height: 20),
                                // Hasil muncul di bawah tombol
                                if (feedbackMessage != null)
                                    Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(color: feedbackColor, borderRadius: BorderRadius.circular(8)),
                                        child: Text(
                                            feedbackMessage!, 
                                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                        ),
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
