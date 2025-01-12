import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/util/constants.dart';

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

  void loadRewardAd() {
    try {
      isAdReady.value = true;

      RewardedAd.load(
        adUnitId: getRewardADUnit(),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            log('Rewarded ad loaded');
            isAdReady.value = true;

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                log('Ad showed fullscreen content');
              },
              onAdDismissedFullScreenContent: (ad) {
                log('Ad dismissed fullscreen content');
                ad.dispose();
                isAdReady.value = false;
                // 광고 닫기 버튼 클릭 시 처리할 로직

                systemProvider.incrementPoint(ADDRESS_TRANSLATE_INCREMENT_POINT);
              },
              onAdFailedToShowFullScreenContent: (ad, err) {
                log('Ad failed to show fullscreen content: $err');
                ad.dispose();
                isAdReady.value = false;
              },
              onAdImpression: (ad) {
                log('Ad impression');
              },
            );

            ad.show(onUserEarnedReward: (ad, reward) {
              log('User earned reward: $reward');
            });
          },
          onAdFailedToLoad: (err) {
            log('Rewarded ad failed to load: $err');
            isAdReady.value = false;
          },
        ),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  void loadBannerAd() {
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
