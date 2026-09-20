import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wicaraplusapp/app_version_config.dart';
import 'package:wicaraplusapp/subscription_service.dart';
import 'package:wicaraplusapp/paywall_page.dart';

class PlayTherapyPage extends StatefulWidget {
  const PlayTherapyPage({super.key});

  @override
  State<PlayTherapyPage> createState() => _PlayTherapyPageState();
}

class TherapyCategory {
  final String title;
  final IconData icon;
  final Color color;
  final bool isPremium;

  TherapyCategory({
    required this.title,
    required this.icon,
    required this.color,
    this.isPremium = true,
  });
}

final List<TherapyCategory> playCategories = [
  TherapyCategory(title: "Mengenal Huruf", icon: Icons.sort_by_alpha, color: Colors.red, isPremium: false),
  TherapyCategory(title: "Mengenal Angka", icon: Icons.format_list_numbered, color: Colors.orange, isPremium: false),
  TherapyCategory(title: "Bentuk", icon: Icons.category, color: Colors.blue, isPremium: false),
  TherapyCategory(title: "Warna", icon: Icons.color_lens, color: Colors.purple, isPremium: false),
  TherapyCategory(title: "Binatang", icon: Icons.pets, color: Colors.green),
  TherapyCategory(title: "Makanan", icon: Icons.restaurant, color: Colors.pink),
  TherapyCategory(title: "Alat Musik", icon: Icons.music_note, color: Colors.teal),
  TherapyCategory(title: "Alat Transportasi", icon: Icons.directions_car, color: Colors.indigo),
  TherapyCategory(title: "Benda", icon: Icons.toys, color: Colors.amber),
  TherapyCategory(title: "Anggota Tubuh", icon: Icons.accessibility_new, color: Colors.cyan),
  TherapyCategory(title: "Anggota Keluarga", icon: Icons.family_restroom, color: Colors.brown),
];

class TherapyGameOption {
  final String text;
  final String imagePath;

  TherapyGameOption({required this.text, required this.imagePath});
  
  @override
  bool operator ==(Object other) => identical(this, other) || other is TherapyGameOption && text == other.text;
  
  @override
  int get hashCode => text.hashCode;
}

class TherapyGameItem {
  final String questionText;
  final String questionAudio;
  final List<TherapyGameOption> options;
  final TherapyGameOption correctOption;

  TherapyGameItem({
    required this.questionText,
    required this.questionAudio,
    required this.options,
    required this.correctOption,
  });
}

class TherapyGameData {
  static List<TherapyGameItem> getMockQuestionsForCategory(String title) {
    switch (title) {
      case "Mengenal Huruf":
        return [
          TherapyGameItem(
            questionText: "Pilih huruf A!",
            questionAudio: "audio/q_huruf_a.mp3",
            options: [
              TherapyGameOption(text: "A", imagePath: "assets/image/Vokal_A.png"),
              TherapyGameOption(text: "B", imagePath: "assets/image/Kons_B.png"),
              TherapyGameOption(text: "C", imagePath: "assets/image/Kons_C.png"),
            ],
            correctOption: TherapyGameOption(text: "A", imagePath: "assets/image/Vokal_A.png"),
          ),
          TherapyGameItem(
            questionText: "Pilih huruf I!",
            questionAudio: "audio/q_huruf_i.mp3",
            options: [
              TherapyGameOption(text: "E", imagePath: "assets/image/Vokal_E.png"),
              TherapyGameOption(text: "I", imagePath: "assets/image/Vokal_I.jpg"),
              TherapyGameOption(text: "O", imagePath: "assets/image/Vokal_O.png"),
            ],
            correctOption: TherapyGameOption(text: "I", imagePath: "assets/image/Vokal_I.jpg"),
          )
        ];
      case "Mengenal Angka":
        return [
          TherapyGameItem(
            questionText: "Pilih angka 1!",
            questionAudio: "audio/q_angka_1.mp3",
            options: [
              TherapyGameOption(text: "1", imagePath: "assets/image/angka_1.png"),
              TherapyGameOption(text: "2", imagePath: "assets/image/angka_2.png"),
              TherapyGameOption(text: "3", imagePath: "assets/image/angka_3.png"),
            ],
            correctOption: TherapyGameOption(text: "1", imagePath: "assets/image/angka_1.png"),
          ),
        ];
      case "Bentuk":
        return [
          TherapyGameItem(
            questionText: "Pilih bentuk Lingkaran!",
            questionAudio: "audio/q_lingkaran.mp3",
            options: [
              TherapyGameOption(text: "Kotak", imagePath: "assets/image/bentuk_kotak.png"),
              TherapyGameOption(text: "Lingkaran", imagePath: "assets/image/bentuk_lingkaran.png"),
              TherapyGameOption(text: "Segitiga", imagePath: "assets/image/bentuk_segitiga.png"),
            ],
            correctOption: TherapyGameOption(text: "Lingkaran", imagePath: "assets/image/bentuk_lingkaran.png"),
          ),
        ];
      case "Warna":
        return [
          TherapyGameItem(
            questionText: "Pilih warna Merah!",
            questionAudio: "audio/q_warna_merah.mp3",
            options: [
              TherapyGameOption(text: "Merah", imagePath: "assets/image/warna_merah.png"),
              TherapyGameOption(text: "Biru", imagePath: "assets/image/warna_biru.png"),
              TherapyGameOption(text: "Hijau", imagePath: "assets/image/warna_hijau.png"),
            ],
            correctOption: TherapyGameOption(text: "Merah", imagePath: "assets/image/warna_merah.png"),
          ),
        ];
      case "Binatang":
        return [
          TherapyGameItem(
            questionText: "Pilih Kucing!",
            questionAudio: "audio/q_kucing.mp3",
            options: [
              TherapyGameOption(text: "Anjing", imagePath: "assets/image/hewan_anjing.png"),
              TherapyGameOption(text: "Kucing", imagePath: "assets/image/hewan_kucing.png"),
              TherapyGameOption(text: "Burung", imagePath: "assets/image/hewan_burung.png"),
            ],
            correctOption: TherapyGameOption(text: "Kucing", imagePath: "assets/image/hewan_kucing.png"),
          ),
        ];
      case "Makanan":
        return [
          TherapyGameItem(
            questionText: "Pilih Apel!",
            questionAudio: "audio/q_apel.mp3",
            options: [
              TherapyGameOption(text: "Pisang", imagePath: "assets/image/pisang.png"),
              TherapyGameOption(text: "Jeruk", imagePath: "assets/image/jeruk.png"),
              TherapyGameOption(text: "Apel", imagePath: "assets/image/apel.png"),
            ],
            correctOption: TherapyGameOption(text: "Apel", imagePath: "assets/image/apel.png"),
          ),
        ];
      case "Alat Musik":
        return [
          TherapyGameItem(
            questionText: "Pilih Gitar!",
            questionAudio: "audio/q_gitar.mp3",
            options: [
              TherapyGameOption(text: "Gitar", imagePath: "assets/image/gitar.png"),
              TherapyGameOption(text: "Piano", imagePath: "assets/image/piano.png"),
              TherapyGameOption(text: "Drum", imagePath: "assets/image/drum.png"),
            ],
            correctOption: TherapyGameOption(text: "Gitar", imagePath: "assets/image/gitar.png"),
          ),
        ];
      case "Alat Transportasi":
        return [
          TherapyGameItem(
            questionText: "Pilih Mobil!",
            questionAudio: "audio/q_mobil.mp3",
            options: [
              TherapyGameOption(text: "Mobil", imagePath: "assets/image/mobil.png"),
              TherapyGameOption(text: "Motor", imagePath: "assets/image/motor.png"),
              TherapyGameOption(text: "Pesawat", imagePath: "assets/image/pesawat.png"),
            ],
            correctOption: TherapyGameOption(text: "Mobil", imagePath: "assets/image/mobil.png"),
          ),
        ];
      case "Benda":
        return [
          TherapyGameItem(
            questionText: "Pilih Baju!",
            questionAudio: "audio/q_baju.mp3",
            options: [
              TherapyGameOption(text: "Baju", imagePath: "assets/image/baju.png"),
              TherapyGameOption(text: "Celana", imagePath: "assets/image/celana.png"),
              TherapyGameOption(text: "Sepatu", imagePath: "assets/image/sepatu.png"),
            ],
            correctOption: TherapyGameOption(text: "Baju", imagePath: "assets/image/baju.png"),
          ),
        ];
      case "Anggota Tubuh":
        return [
          TherapyGameItem(
            questionText: "Pilih Mata!",
            questionAudio: "audio/q_mata.mp3",
            options: [
              TherapyGameOption(text: "Hidung", imagePath: "assets/image/hidung.png"),
              TherapyGameOption(text: "Mata", imagePath: "assets/image/mata.png"),
              TherapyGameOption(text: "Telinga", imagePath: "assets/image/telinga.png"),
            ],
            correctOption: TherapyGameOption(text: "Mata", imagePath: "assets/image/mata.png"),
          ),
        ];
      case "Anggota Keluarga":
        return [
          TherapyGameItem(
            questionText: "Pilih Ayah!",
            questionAudio: "audio/q_ayah.mp3",
            options: [
              TherapyGameOption(text: "Ibu", imagePath: "assets/image/ibu.png"),
              TherapyGameOption(text: "Ayah", imagePath: "assets/image/Kata_Papa.jpg"),
              TherapyGameOption(text: "Kakek", imagePath: "assets/image/kakek.png"),
            ],
            correctOption: TherapyGameOption(text: "Ayah", imagePath: "assets/image/Kata_Papa.jpg"),
          ),
        ];
      default:
        return [
           TherapyGameItem(
            questionText: "Siap bermain?",
            questionAudio: "audio/q_siap.mp3",
            options: [
              TherapyGameOption(text: "Ya", imagePath: "assets/image/ya.png"),
              TherapyGameOption(text: "Mungkin", imagePath: "assets/image/mungkin.png"),
              TherapyGameOption(text: "Tidak", imagePath: "assets/image/tidak.png"),
            ],
            correctOption: TherapyGameOption(text: "Ya", imagePath: "assets/image/ya.png"),
          ),
        ];
    }
  }
}

class PlayTherapyCategoryPage extends StatefulWidget {
  final TherapyCategory category;

  const PlayTherapyCategoryPage({super.key, required this.category});

  @override
  State<PlayTherapyCategoryPage> createState() => _PlayTherapyCategoryPageState();
}

class _PlayTherapyCategoryPageState extends State<PlayTherapyCategoryPage> {
  late List<TherapyGameItem> _questions;
  int _currentIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _questions = TherapyGameData.getMockQuestionsForCategory(widget.category.title);
    _playQuestionAudio();
  }

  Future<void> _playQuestionAudio() async {
    if (_questions.isNotEmpty && _currentIndex < _questions.length) {
      try {
        await _audioPlayer.play(AssetSource(_questions[_currentIndex].questionAudio));
      } catch (e) {
        // Handle audio file not present gracefully
      }
    }
  }

  void _checkAnswer(TherapyGameOption selected) async {
    final correct = selected == _questions[_currentIndex].correctOption;
    if (correct) {
      try {
        await _audioPlayer.play(AssetSource('audio/Hasil_Ya.mp3'));
      } catch (e) {
        // ignore fallback silently
      }
      _showFeedback(true);
    } else {
      try {
        await _audioPlayer.play(AssetSource('audio/Hasil_Tidak.mp3'));
      } catch (e) {
        // ignore
      }
      _showFeedback(false);
    }
  }

  void _showFeedback(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                isCorrect ? "Ya!" : "Tidak!",
                style: TextStyle(
                  color: isCorrect ? Colors.green : Colors.red,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCorrect ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (isCorrect) {
                    setState(() {
                      if (_currentIndex < _questions.length - 1) {
                        _currentIndex++;
                        _playQuestionAudio();
                      } else {
                        Navigator.pop(context); // Finish game back to list
                      }
                    });
                  } else {
                    _playQuestionAudio(); // replay question if wrong
                  }
                },
                child: Text(isCorrect ? "Lanjut" : "Coba Lagi", style: const TextStyle(fontSize: 18)),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget _buildOptionCard(TherapyGameOption option) {
    return GestureDetector(
      onTap: () => _checkAnswer(option),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.category.color, width: 4),
          boxShadow: [
            BoxShadow(
              color: widget.category.color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    option.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(widget.category.icon, size: 64, color: widget.category.color),
                          const SizedBox(height: 8),
                          Text(
                            option.text,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.category.color),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category.title), backgroundColor: widget.category.color),
        body: const Center(child: Text("Materi belum tersedia.")),
      );
    }

    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: widget.category.color.withValues(alpha: 0.05),
      appBar: AppBar(
        title: Text(widget.category.title),
        backgroundColor: widget.category.color,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Question Prompt Area
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Pertanyaan ${_currentIndex + 1} dari ${_questions.length}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentQuestion.questionText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.category.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IconButton(
                    iconSize: 48,
                    color: widget.category.color,
                    icon: const Icon(Icons.volume_up_rounded),
                    onPressed: _playQuestionAudio,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Options Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 0.8,
                  children: currentQuestion.options.map((opt) => _buildOptionCard(opt)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayTherapyPageState extends State<PlayTherapyPage> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _hasAccess = false;
  bool _autoUnlock = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terapi Bermain"),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_autoUnlock) _buildAutoBanner(),
            if (!_hasAccess && !_autoUnlock) _buildLockedBanner(),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: playCategories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(playCategories[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoBanner() {
    final msg = AppVersionConfig.accessStatusMessage();
    if (msg.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        children: [
          const Text(
            "Fitur Lengkap Tersedia untuk Premium",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await _subscriptionService.startTrial();
              await _checkStatus();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Masa percobaan 7 hari dimulai!")),
                );
              }
            },
            child: const Text("Mulai Uji Coba Gratis 7 Hari"),
          ),
          TextButton(
            onPressed: () async {
              await _subscriptionService.setPremiumLocal(true);
              await _checkStatus();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Anda telah berlangganan Premium!")),
                );
              }
            },
            child: const Text("Langganan Rp99.000/bln"),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(TherapyCategory category) {
    bool isLocked = category.isPremium && !_hasAccess && !_autoUnlock;

    return GestureDetector(
      onTap: () async {
        if (isLocked) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaywallPage()),
          );
          
          if (result == true) {
            _checkStatus();
          }
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayTherapyCategoryPage(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: category.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: category.color, width: 4),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category.icon, size: 50, color: category.color),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      category.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: category.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked)
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 14,
                  child: Icon(Icons.lock, color: Colors.orange, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
