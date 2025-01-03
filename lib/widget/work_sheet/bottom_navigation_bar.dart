import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/db/work_sheet.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/work_sheet.dart';
import 'package:life_secretary/util/constants.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({super.key});

  final SystemProvider systemProvider = Get.put(SystemProvider());
  final WorkSheetHalper workSheetHalper = WorkSheetHalper();
  final WorkSheetProvider workSheetProvider = Get.put(WorkSheetProvider());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
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
            workSheetProvider.startWork();
          } else if (index == 1) {
            workSheetProvider.endWork();
          } else if (index == 2) {
            Get.defaultDialog(
              title: 'workRefreshTimeSetting'.tr,
              content: Obx(
                () => Column(
                  children: [
                    DropdownMenu(
                      dropdownMenuEntries: List.generate(16, (index) {
                        final minutes = (index + 1) * 30;
                        final hours = minutes ~/ 60;
                        final remainingMinutes = minutes % 60;
                        final label = hours > 0 ? '$hours:$remainingMinutes' : '$remainingMinutes';
                        return DropdownMenuEntry(
                          label: label,
                          value: minutes,
                        );
                      }),
                      onSelected: (value) {
                        log('>>>>>>>>>>>>>>>>>>>> value: $value');
                        if (value == null) {
                          return;
                        }

                        workSheetProvider.refreshTime.value = value;
                      },
                    ),
                    if (workSheetProvider.refreshTime.value > 0)
                      ElevatedButton(
                        onPressed: () {
                          log('>>>>>>>>>>>>>>>>>>>> 휴식');
                          workSheetProvider.refreshTime.value = 0;
                          Get.back();
                        },
                        child: Text('workRefresh'.tr),
                      ),
                  ],
                ),
              ),
            );
          } else if (index == 3) {
            log('>>>>>>>>>>>>>>>>>>>> 통계');
          }
        },
      ),
    );
  }
}
