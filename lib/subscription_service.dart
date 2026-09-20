import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicaraplusapp/app_version_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

/// SubscriptionService
///
/// Mengatur akses konten premium dengan mempertimbangkan:
/// 1. Flavor build (closedBeta / publicBeta / production)
/// 2. Periode gratis 7 hari untuk production
/// 3. Status langganan berbayar pengguna (RevenueCat)
/// 4. Status trial manual 7 hari
class SubscriptionService {
  static const String _kIsPremiumLocal = 'is_premium';
  static const String _kTrialStartDate = 'trial_start_date';
  static const int _kTrialDays = 7;

  // Entitlement ID sesuai permintaan
  static const String entitlementId = 'Spesial Karya Mandiri Pro';

  // API Key sesuai permintaan
  static const _apiKey = "test_shfeNUKFtJCjVryHMJMAKzqIgRq";

  // ─── Inisialisasi ─────────────────────────────────────────────────────────

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);
    await Purchases.configure(configuration);
  }

  // ─── Cek Status Langganan (Real IAP) ──────────────────────────────────────

  Future<bool> isPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      bool isPremiumActive = customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
      
      if (isPremiumActive) {
        await setPremiumLocal(true);
      }
      
      return isPremiumActive;
    } catch (e) {
      return await getPremiumLocal();
    }
  }

  Future<void> purchaseProduct(Package package) async {
    try {
      await Purchases.purchase(PurchaseParams.package(package));
    } catch (e) {
      rethrow;
    }
  }

  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      return null;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await Purchases.restorePurchases();
    } catch (e) {
      rethrow;
    }
  }

  /// Menampilkan RevenueCat Paywall (Native UI)
  Future<void> presentPaywall() async {
    try {
      await RevenueCatUI.presentPaywall();
    } catch (e) {
      // Fallback atau error handling
    }
  }

  /// Menampilkan Customer Center untuk manajemen langganan
  Future<void> presentCustomerCenter() async {
    try {
      await RevenueCatUI.presentCustomerCenter();
    } catch (e) {
      // Fallback
    }
  }

  // ─── Cek Status Trial & Local ─────────────────────────────────────────────

  Future<bool> getPremiumLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsPremiumLocal) ?? false;
  }

  Future<void> setPremiumLocal(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsPremiumLocal, value);
  }

  Future<bool> isTrialActive() async {
    final prefs = await SharedPreferences.getInstance();
    final trialStartStr = prefs.getString(_kTrialStartDate);
    if (trialStartStr == null) return false;

    final trialStart = DateTime.parse(trialStartStr);
    final now = DateTime.now();
    final difference = now.difference(trialStart).inDays;
    return difference < _kTrialDays;
  }

  Future<void> startTrial() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_kTrialStartDate)) {
      await prefs.setString(_kTrialStartDate, DateTime.now().toIso8601String());
    }
  }

  // ─── Cek Akses Konten (Utama) ─────────────────────────────────────────────

  Future<bool> canAccessAllContent() async {
    if (AppVersionConfig.hasAutoFullAccess()) return true;
    if (await isPremium()) return true;
    if (await isTrialActive()) return true;
    return false;
  }

  Future<bool> shouldShowAds() async {
    return !(await canAccessAllContent());
  }

  Future<bool> shouldShowPaywall() async {
    if (AppVersionConfig.hasAutoFullAccess()) return false;
    return !(await canAccessAllContent());
  }
}


