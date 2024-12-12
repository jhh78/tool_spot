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
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          child: Column(
            children: [
              Obx(() => renderDropdownMenu()),
              // 국가별 국기 아이콘 추가
            ],
          ),
        ),
        // Add more PopupMenuItem widgets for additional submenus
      ],
    );
  }

  DropdownButton<String> renderDropdownMenu() {
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(20.0),
      isExpanded: true, // This makes the dropdown take the full width
      icon: const Icon(Icons.language_outlined),
      alignment: AlignmentDirectional.center,
      underline: Container(height: 0),
      value: systemProvider.language.value,
      onChanged: (String? newValue) {
        if (newValue != null) {
          systemProvider.changeLanguage(newValue);
        }
      },
      items: <String>['en', 'ko', 'ja'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text('language_$value'.tr),
        );
      }).toList(),
    );
  }
}
