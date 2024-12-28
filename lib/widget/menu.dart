import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/util/util.dart';
import 'package:life_secretary/widget/menu_card.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({
    super.key,
  });

  final SystemProvider systemProvider = Get.put(SystemProvider());
  final RouterProvider routerProvider = Get.put(RouterProvider());

  @override
  Widget build(BuildContext context) {
    final List<MenuCard> menuCards = [
      MenuCard(
        icon: Icons.qr_code_rounded,
        callback: () => routerProvider.moveQRReader(),
      ),
      MenuCard(
        icon: Icons.translate,
        callback: () => routerProvider.moveAddressTranslate(),
      ),
      // MenuCard(
      //   icon: Icons.format_list_numbered,
      //   callback: () {
      //     Get.to(() => const TodoScreen());
      //   },
      //   text: 'Todo'.tr,
      // ),
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
    return Padding(
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
    );
  }
}
