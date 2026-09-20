import 'package:flutter/material.dart';
import 'package:wicaraplusapp/app_version_config.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/image/Logo_WICARAplus_trans.png", width: 250),
              const Text(
                "Tentang Aplikasi",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "Versi ${AppVersionConfig.versionCode}",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/Andre.jpg',
                    width: 75,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 50),
                  Image.asset(
                    'assets/image/Ryan.jpg',
                    width: 75,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                "Andre (Kiri) dan Ryan (Kanan), Pembuat Aplikasi WICARA+",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "WICARA+ (dibaca Wicara Plus) adalah aplikasi terapi wicara yang dirancang untuk mendukung terapi konsentrasi dan terapi kognitif. "
                "Aplikasi ini ditujukan untuk anak berkebutuhan khusus, guru, terapis dan orang tua agar proses belajar menjadi lebih menyenangkan dan efektif. "
                "Aplikasi ini dibuat oleh penyandang autisme, yaitu Andre dan Ryan.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}