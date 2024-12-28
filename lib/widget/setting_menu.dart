import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/vender/ad.dart';

class SettingMenu extends StatelessWidget {
  SettingMenu({
    super.key,
  });

  final SystemProvider systemProvider = Get.put(SystemProvider());
  final ADManager adManager = Get.put(ADManager());
  final double iconSize = 32.0;

  Switch renderSwitchMenuItem() {
    return Switch(
      value: systemProvider.themeMode.value == ThemeMode.dark,
      onChanged: (bool value) {
        systemProvider.changeTheme();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'pointAdd') {
          adManager.loadRewardAd();
        }
      },
      icon: const Icon(
        Icons.settings,
        size: 32,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'setting',
          child: SizedBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.light_mode_outlined,
                      size: iconSize,
                    ),
                    Obx(() => renderSwitchMenuItem()),
                    Icon(
                      Icons.dark_mode_outlined,
                      size: iconSize,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'pointAdd',
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.play_circle_outline_sharp,
                  size: iconSize,
                ),
                Text('pointAdd'.tr),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
