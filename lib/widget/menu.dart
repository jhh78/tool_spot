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
        callback: () => routerProvider.moveQRReader(context),
      ),
      MenuCard(
        icon: Icons.translate,
        callback: () => routerProvider.moveAddressTranslate(context),
      ),
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
