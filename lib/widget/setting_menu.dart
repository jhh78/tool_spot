import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/system.dart';

class SettingMenu extends StatelessWidget {
  SettingMenu({
    super.key,
  });

  final SystemProvider systemProvider = Get.find<SystemProvider>();

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
      icon: const Icon(
        Icons.settings,
        size: 32,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.light_mode_outlined),
                Obx(() => renderSwitchMenuItem()),
                const Icon(Icons.dark_mode_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
