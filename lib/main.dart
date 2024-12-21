import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/translate_text.dart';
import 'package:life_secretary/screen/main_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// TODO ::: 바코드 스캐너 추가
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  if (kDebugMode) {
    await Upgrader.clearSavedSettings();
  }

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final SystemProvider systemProvider = Get.put(SystemProvider());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        translations: TranslateText(), // 다국어 번역 클래스 추가
        locale: Get.deviceLocale, // 기기 설정 언어로 설정
        fallbackLocale: const Locale('en', 'US'), // 기본 언어 설정
        theme: ThemeData(
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: systemProvider.themeMode.value,
        home: UpgradeAlert(
          barrierDismissible: false,
          showIgnore: false,
          showLater: false,
          child: const MainScreen(),
        ),
      );
    });
  }
}
