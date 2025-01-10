import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/work_sheet.dart';
import 'package:life_secretary/widget/work_sheet/home.dart';
import 'package:life_secretary/widget/work_sheet/modify_form.dart';

class WorkSheetScreen extends StatefulWidget {
  const WorkSheetScreen({super.key});

  @override
  State<WorkSheetScreen> createState() => _WorkSheetScreenState();
}

class _WorkSheetScreenState extends State<WorkSheetScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final SystemProvider systemProvider = Get.put(SystemProvider());
  final WorkSheetProvider workSheetProvider = Get.put(WorkSheetProvider());

  int screenIndex = 0;

  void changeScreen(int index) {
    setState(() {
      screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: screenIndex,
        children: [
          WorkSheetHomeScreen(
            changeScreen: changeScreen,
          ),
          WorkSheetModifyScreen(
            changeScreen: changeScreen,
          ),
        ],
      ),
    );
  }
}
