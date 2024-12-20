import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:life_secretary/util/hive.dart';

class SystemProvider extends GetxService {
  late Box systemBox;
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSystemData();
  }

  void _loadSystemData() async {
    systemBox = await Hive.openBox(THEME_MODE);
    final theme = systemBox.get(THEME_MODE);
    if (theme != null) {
      themeMode.value = ThemeMode.values[theme];
    } else {
      themeMode.value = ThemeMode.light;
    }
  }

  void changeTheme() async {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
    systemBox.put(THEME_MODE, themeMode.value.index);
  }
}
