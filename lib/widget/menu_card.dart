import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/util/util.dart';

class MenuCard extends StatelessWidget {
  MenuCard({
    super.key,
    required this.descript,
    required this.icon,
    required this.callback,
    this.isRotate = false,
  });

  final String descript;
  final IconData icon;
  final Function callback;
  final bool isRotate;
  final SystemProvider systemProvider = Get.put(SystemProvider());

  Widget renderIcon(BuildContext context) {
    if (isRotate) {
      return Transform.rotate(
        angle: 90 * 3.1415927 / 180, // 90도 회전 (라디안 단위)
        child: Obx(
          () => Icon(
            icon,
            size: getIconSize(context),
            color: systemProvider.getSystemThemeColor(),
          ),
        ),
      );
    }
    return Obx(() => Icon(
          icon,
          size: getIconSize(context),
          color: systemProvider.getSystemThemeColor(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      splashColor: Colors.blue.withAlpha(50), // 눌림 효과 색상
      highlightColor: Colors.blue.withAlpha(50), // 강조 색상
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          children: [
            renderIcon(context),
            Text(
              descript,
            ),
          ],
        ),
      ),
    );
  }
}
