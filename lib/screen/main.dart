import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/vender/ad.dart';
import 'package:life_secretary/screen/qr_reader.dart';
import 'package:life_secretary/screen/address_translate.dart';
import 'package:life_secretary/widget/menu.dart';
import 'package:life_secretary/widget/setting_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final ADManager adManager = Get.put(ADManager());
  bool isReady = false;

  Widget _renderAppBarTitle() {
    switch (routerProvider.screenIndex.value) {
      case 0:
        return Text("mainHomeTitle".tr);
      case 1:
        return Text("qrReaderTitle".tr);
      case 2:
        return Text("addressTranslate".tr);
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
        icon: const Icon(Icons.home),
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
