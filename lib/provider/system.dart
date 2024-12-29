import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:life_secretary/util/hive.dart';

class SystemProvider extends GetxService {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  RxInt screenIndex = 0.obs;
  RxInt point = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSystemData();
    _loadPoint();
  }

  void _loadPoint() async {
    final Box pointBox = await Hive.openBox(POINT);
    final point = pointBox.get(POINT);
    if (point != null) {
      this.point.value = point;
    }
  }

  void _loadSystemData() async {
    final Box themeBox = await Hive.openBox(THEME_MODE);
    final theme = themeBox.get(THEME_MODE);
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
    final Box themeBox = await Hive.openBox(THEME_MODE);
    themeBox.put(THEME_MODE, themeMode.value.index);
  }

  void changeScreenIndex(int index) {
    screenIndex.value = index;
  }

  void incrementPoint(int point) async {
    this.point.value += point;

    final Box pointBox = await Hive.openBox(POINT);
    pointBox.put(POINT, this.point.value);
  }

  void decrementPoint(int point) async {
    this.point.value -= point;

    final Box pointBox = await Hive.openBox(POINT);
    pointBox.put(POINT, this.point.value);
  }
}
