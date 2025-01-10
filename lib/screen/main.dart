import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/vender/ad.dart';
import 'package:life_secretary/screen/qr_reader.dart';
import 'package:life_secretary/screen/address_translate.dart';
import 'package:life_secretary/screen/work_sheet.dart';
import 'package:life_secretary/util/constants.dart';
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

  @override
  void initState() {
    super.initState();
    routerProvider.homeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    routerProvider.homeFocusNode.removeListener(_onFocusChange);
    routerProvider.homeFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (routerProvider.homeFocusNode.hasFocus) {
      log('>>>>>>>>>>>>>>>>>>>> MainScreen screen has focus');
    }
  }

  Widget _renderAppBarTitle() {
    switch (routerProvider.screenIndex.value) {
      case 0:
        return Text("mainHomeTitle".tr);
      case 1:
        return Text("qrReaderTitle".tr);
      case 2:
        return Text("addressTranslate".tr);
      case 3:
        return Text("timeSheet".tr);
      default:
        return Text("mainHomeTitle".tr);
    }
  }

  Widget? _renderLeadingWidget(BuildContext context) {
    if (routerProvider.screenIndex.value != 0) {
      return IconButton(
        onPressed: () {
          routerProvider.moveHome(context);
        },
        icon: Icon(
          Icons.home_outlined,
          size: ICON_SIZE,
          color: systemProvider.getSystemThemeColor(),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => _renderAppBarTitle(),
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
          Column(
            children: [
              Expanded(
                child: Obx(
                  () => IndexedStack(
                    index: routerProvider.screenIndex.value,
                    children: [
                      MenuScreen(),
                      const QrReaderScreen(),
                      const AddressTranslate(),
                      const WorkSheetScreen(),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        child: Align(
          alignment: Alignment.center,
          child: Obx(
            () => adManager.bannerAd.value == null
                ? const SizedBox(
                    child: Text("Banner AD Area\nRelease Mode Only"),
                  )
                : AdWidget(ad: adManager.bannerAd.value!),
          ),
        ),
      ),
    );
  }
}
