import 'package:flutter/material.dart';
import 'package:wicaraplusapp/subscription_service.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Secara otomatis tampilkan native paywall saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNativePaywall();
    });
  }

  Future<void> _showNativePaywall() async {
    setState(() => _isLoading = true);
    
    // Menampilkan Paywall Native dari RevenueCat
    // Pastikan Anda sudah mengonfigurasi Paywall di Dashboard RevenueCat
    await _subscriptionService.presentPaywall();
    
    if (mounted) {
      setState(() => _isLoading = false);
      // Cek apakah user jadi premium setelah menutup paywall
      bool isPremium = await _subscriptionService.isPremium();
      if (!mounted) return;
      if (isPremium) {
        Navigator.of(context).pop(true);
      } else {
        // Jika tidak jadi beli, tetap di sini atau biarkan user menutup manual
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Premium Access', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium_rounded, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              'Buka Semua Fitur Premium',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _showNativePaywall,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Lihat Penawaran'),
              ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _subscriptionService.presentCustomerCenter(),
              child: const Text('Kelola Langganan'),
            ),
          ],
        ),
      ),
    );
  }
}


