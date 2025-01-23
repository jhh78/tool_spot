import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:life_secretary/db/helper.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/translate_text.dart';
import 'package:life_secretary/screen/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kDebugMode) {
    await Upgrader.clearSavedSettings();
  }

  await DatabaseHelper().initDatabase();
  await dotenv.load(fileName: ".env");

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  await initializeDateFormatting();
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
        debugShowCheckedModeBanner: false,
        translations: TranslateText(), // 다국어 번역 클래스 추가
        locale: Get.deviceLocale, // 기기 설정 언어로 설정
        fallbackLocale: const Locale('ko', 'KR'), // 기본 언어 설정
        theme: ThemeData(
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: systemProvider.themeMode.value,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), // 텍스트 스케일 팩터 고정
            child: child!,
          );
        },
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
