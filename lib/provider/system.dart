import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:life_secretary/util/hive.dart';

class SystemProvider extends GetxService {
  late Box systemBox;
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  Rx<String> language = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    log('SystemProvider initialized');

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

    final lang = systemBox.get(LANGUAGE_MODE);
    if (lang != null) {
      language.value = lang;
    } else {
      language.value = 'en';
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

  void changeLanguage(String language) async {
    this.language.value = language;
    systemBox.put(LANGUAGE_MODE, language);
    Get.updateLocale(Locale(language));
  }
}
