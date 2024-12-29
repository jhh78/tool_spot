import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/vender/ad.dart';
import 'package:life_secretary/util/constants.dart';

class SettingMenu extends StatelessWidget {
  SettingMenu({
    super.key,
  });

  final SystemProvider systemProvider = Get.put(SystemProvider());
  final ADManager adManager = Get.put(ADManager());

  Switch renderSwitchMenuItem() {
    return Switch(
      value: systemProvider.themeMode.value == ThemeMode.dark,
      inactiveThumbColor: Colors.grey, // 비활성화된 스위치의 썸 색상
      inactiveTrackColor: Colors.grey[100], // 비활성화된 스위치의 트랙 색상
      activeColor: Colors.white70, // 활성화된 스위치의 색상
      activeTrackColor: Colors.black54, // 활성화된 스위치의 트랙 색상
      onChanged: (bool value) {
        systemProvider.changeTheme();
      },
    );
  }

  Color getThemeColor() {
    return systemProvider.themeMode.value == ThemeMode.dark ? Colors.white70 : Colors.black54;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'pointAdd') {
            adManager.loadRewardAd();
          }
        },
        icon: const Icon(
          Icons.settings,
          size: ICON_SIZE,
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'setting',
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.light_mode_outlined,
                    size: ICON_SIZE,
                    color: getThemeColor(),
                  ),
                  renderSwitchMenuItem(),
                  Icon(
                    Icons.dark_mode_outlined,
                    size: ICON_SIZE,
                    color: getThemeColor(),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'pointAdd',
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.play_circle_outline_sharp,
                    size: ICON_SIZE,
                    color: getThemeColor(),
                  ),
                  Text(
                    'pointAdd'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: getThemeColor(),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
