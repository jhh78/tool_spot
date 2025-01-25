import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/vender/ad.dart';
import 'package:life_secretary/screen/alarm.dart';
import 'package:life_secretary/screen/holiday_calender.dart';
import 'package:life_secretary/screen/qr_reader.dart';
import 'package:life_secretary/screen/address_translate.dart';
import 'package:life_secretary/screen/zipcode_search.dart';
import 'package:life_secretary/util/styles.dart';
import 'package:life_secretary/widget/menu.dart';
import 'package:life_secretary/widget/setting_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final SystemProvider systemProvider = Get.put(SystemProvider());
  final ADManager adManager = Get.put(ADManager());

  bool isReady = false;
  final Map<String, Widget Function()> pages = {
    ROUTER_HOME: () => MenuScreen(),
    ROUTER_QRREADER: () => const QrReaderScreen(),
    ROUTER_ADDRESSTRANSLATE: () => const AddressTranslate(),
    ROUTER_HOLIDAY_CALENDER: () => const HolidayCalenderScreen(),
    ROUTER_ZIPCODE_SEARCH: () => const ZipcodeSearchScreen(),
    // ROUTER_ALARM: () => const LifeAlarmScreen(),
  };

  @override
  void initState() {
    log('\t\t\t\t\t\t\t\t\t\t MainScreen screen init');
    super.initState();
    routerProvider.homeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    log('\t\t\t\t\t\t\t\t\t\t MainScreen screen dispose');
    routerProvider.homeFocusNode.removeListener(_onFocusChange);
    routerProvider.homeFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (routerProvider.homeFocusNode.hasFocus) {
      log('\t\t\t\t\t\t\t\t\t\t MainScreen screen has focus');
    }
  }

  Widget? _renderLeadingWidget(BuildContext context) {
    if (routerProvider.currentScreen.value == ROUTER_HOME) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () {
        routerProvider.changeScreen(context, ROUTER_HOME);
      },
      icon: Icon(
        Icons.home_outlined,
        size: ICON_SIZE_32,
        color: systemProvider.getSystemThemeColor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(routerProvider.getAppBarTitle()),
        ),
        leading: Obx(
          () => _renderLeadingWidget(context) ?? const SizedBox.shrink(),
        ),
        centerTitle: true,
        actions: [
          SettingMenu(),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            return Stack(
              children: pages.entries.map((entry) {
                return Offstage(
                  offstage: routerProvider.currentScreen.value != entry.key,
                  child: Navigator(
                    key: PageStorageKey<String>('Navigator${entry.key}'),
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                        builder: (context) => entry.value(),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          }),
          Obx(() {
            if (adManager.isAdReady.value) {
              return Container(
                color: Colors.black.withAlpha(200),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return const SizedBox.shrink();
          })
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        child: Obx(
          () => adManager.bannerAd.value == null
              ? const Center(
                  child: SizedBox(
                    child: Text("Banner AD Area\nRelease Mode Only"),
                  ),
                )
              : AdWidget(ad: adManager.bannerAd.value!),
        ),
      ),
    );
  }
}
