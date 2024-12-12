import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/widget/menu_card.dart';
import 'package:life_secretary/widget/setting_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

Widget renderMenuRow(BuildContext context, List<MenuCard> cards) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: cards.map((card) => card).toList(),
    ),
  );
}

class _MainScreenState extends State<MainScreen> {
  final SystemProvider systemProvider = Get.find<SystemProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mainHomeTitle'.tr),
        actions: [
          SettingMenu(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            renderMenuRow(context, [
              MenuCard(
                  icon: Icons.map_outlined,
                  callback: () {
                    Get.toNamed('/map');
                  },
                  text: 'mainMenuMap'.tr),
            ]),
            // renderMenuRow(context, [
            //   MenuCard(icon: Icons.shopping_cart),
            //   MenuCard(icon: Icons.restaurant),
            // ]),
            // renderMenuRow(context, [
            //   MenuCard(icon: Icons.directions_car),
            //   MenuCard(icon: Icons.local_hospital),
            // ]),
            // renderMenuRow(context, [
            //   MenuCard(icon: Icons.school),
            //   MenuCard(icon: Icons.work),
            // ]),
            // renderMenuRow(context, [
            //   MenuCard(icon: Icons.fitness_center),
            //   MenuCard(icon: Icons.local_cafe),
            // ]),
            // renderMenuRow(context, [
            //   MenuCard(icon: Icons.movie),
            //   MenuCard(icon: Icons.music_note),
            // ]),
          ],
        ),
      ),
    );
  }
}
