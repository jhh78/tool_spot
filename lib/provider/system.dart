import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:life_secretary/util/hive.dart';

class SystemProvider extends GetxService {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    log('SystemProvider initialized');

    _loadTheme();
  }

  void _loadTheme() async {
    Box<int> themeBox = await Hive.openBox<int>(THEME_BOX);
    final theme = themeBox.get(THEME_MODE);
    if (theme != null) {
      themeMode.value = ThemeMode.values[theme];
    } else {
      themeMode.value = ThemeMode.light;
    }
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
    _saveTheme();
  }

  void _saveTheme() async {
    Box<int> themeBox = await Hive.openBox<int>(THEME_BOX);
    themeBox.put(THEME_MODE, themeMode.value.index);
  }
}
