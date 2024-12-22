import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/screen/qr_reader.dart';
import 'package:life_secretary/util/util.dart';
import 'package:life_secretary/widget/menu_card.dart';
import 'package:life_secretary/widget/setting_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SystemProvider systemProvider = Get.find<SystemProvider>();
  bool isReady = false;

  final List<MenuCard> menuCards = [
    MenuCard(
      icon: Icons.qr_code_rounded,
      callback: () {
        Get.to(() => const QrReaderScreen());
      },
      text: 'QrReader'.tr,
    ),
    MenuCard(
      icon: Icons.format_list_numbered,
      isRotate: true,
      callback: () {},
      text: 'barcode'.tr,
    ),
    // MenuCard(
    //   icon: Icons.restaurant,
    //   callback: () {
    //     // Add your callback here
    //   },
    //   text: 'Restaurant'.tr,
    // ),
    // MenuCard(
    //   icon: Icons.directions_car,
    //   callback: () {
    //     // Add your callback here
    //   },
    //   text: 'Car'.tr,
    // ),
    // MenuCard(
    //   icon: Icons.local_hospital,
    //   callback: () {
    //     // Add your callback here
    //   },
    //   text: 'Hospital'.tr,
    // ),
    // MenuCard(
    //   icon: Icons.school,
    //   callback: () {
    //     // Add your callback here
    //   },
    //   text: 'School'.tr,
    // ),
    // MenuCard(
    //   icon: Icons.work,
    //   callback: () {
    //     // Add your callback here
    //   },
    //   text: 'Work'.tr,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('mainHomeTitle'.tr),
          actions: [
            SettingMenu(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: getGridCardSize(context),
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: menuCards.length,
            itemBuilder: (BuildContext context, int index) {
              return menuCards[index];
            },
          ),
        ));
  }
}
