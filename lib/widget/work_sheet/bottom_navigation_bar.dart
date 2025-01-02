import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/util/constants.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({super.key});

  final SystemProvider systemProvider = Get.put(SystemProvider());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle: TextStyle(color: systemProvider.getSystemThemeColor()),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                size: ICON_SIZE,
                Icons.upload_outlined,
                color: systemProvider.getSystemThemeColor(),
              ),
              label: 'workStart'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: ICON_SIZE,
                Icons.download_outlined,
                color: systemProvider.getSystemThemeColor(),
              ),
              label: 'workEnd'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: ICON_SIZE,
                Icons.local_cafe_outlined,
                color: systemProvider.getSystemThemeColor(),
              ),
              label: 'workRefresh'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: ICON_SIZE,
                Icons.auto_graph_outlined,
                color: systemProvider.getSystemThemeColor(),
              ),
              label: 'workGraph'.tr,
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              log('>>>>>>>>>>>>>>>>>>>> 출근');
            } else if (index == 1) {
              log('>>>>>>>>>>>>>>>>>>>> 퇴근');
            } else if (index == 2) {
              log('>>>>>>>>>>>>>>>>>>>> 휴식');
            } else if (index == 3) {
              log('>>>>>>>>>>>>>>>>>>>> 통계');
            }
          },
        ));
  }
}
