import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:life_secretary/provider/system.dart';

const String location = "lib/services/ad_manager.dart";

class ADManager extends GetxService {
  RxBool isAdReady = false.obs;
  Rx<BannerAd?> bannerAd = Rx<BannerAd?>(null);
  SystemProvider systemProvider = Get.put(SystemProvider());

  @override
  void onInit() {
    super.onInit();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      log('$location: MobileAds initialized');
      loadBannerAd();
    });
  }

  String getRewardADUnit() {
    if (Platform.isAndroid) {
      return kReleaseMode ? "ca-app-pub-9674517651101637/7414309401" : "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return kReleaseMode ? "ca-app-pub-9674517651101637/1365003850" : "ca-app-pub-3940256099942544/1712485313";
    }

    throw Exception("Unsupported platform");
  }

  String getBannerADUnit() {
    if (Platform.isAndroid) {
      return kReleaseMode ? "ca-app-pub-9674517651101637/5331071548" : "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return kReleaseMode ? "ca-app-pub-9674517651101637/9051922188" : "ca-app-pub-3940256099942544/2934735716";
    }

    throw Exception("Unsupported platform");
  }

  Future loadRewardAd() async {
    try {
      final Completer<void> completer = Completer<void>();
      isAdReady.value = true;
      await InterstitialAd.load(
          adUnitId: getRewardADUnit(),
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) async {
              log('Ad loaded. $ad');
              await ad.show();

              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {
                  log('Ad showed fullscreen content: $ad');
                },
                onAdImpression: (ad) {
                  log('Ad impression: $ad');
                  ad.dispose();
                  isAdReady.value = false;
                  systemProvider.setPoint(30);
                },
                onAdClicked: (ad) {
                  log('Ad clicked: $ad');
                },
                onAdFailedToShowFullScreenContent: (ad, err) async {
                  ad.dispose();
                  completer.completeError(Exception('Ad failed to show fullscreen content: $err'));
                },
                onAdDismissedFullScreenContent: (ad) async {
                  ad.dispose();
                  completer.completeError(Exception('Ad dismissed fullscreen content: $ad'));
                },
              );
            },
            onAdFailedToLoad: (error) {
              completer.completeError(Exception('Ad failed to load: $error'));
            },
          )).then((value) {
        completer.complete();
      });

      await completer.future;
    } catch (e) {
      isAdReady.value = false;
      log(e.toString());
      rethrow;
    }
  }

  void loadBannerAd() {
    if (kDebugMode) {
      return;
    }

    bannerAd.value = BannerAd(
      adUnitId: getBannerADUnit(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('$location: Ad loaded: $ad');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('$location: Ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log('$location: Ad opened: $ad'),
        onAdClosed: (Ad ad) => log('$location: Ad closed: $ad'),
        onAdImpression: (Ad ad) => log('$location: Ad impression: $ad'),
        onAdClicked: (Ad ad) => log('$location: Ad clicked: $ad'),
      ),
    )..load();
  }
}
