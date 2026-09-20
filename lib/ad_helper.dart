import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9500376140549576/1924550909'; // ID Test Android Banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9500376140549576/6324495767'; // ID Test iOS Banner
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9500376140549576/9657236111'; // ID Test Android Interstitial
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9500376140549576/2181236624'; // ID Test iOS Interstitial
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
