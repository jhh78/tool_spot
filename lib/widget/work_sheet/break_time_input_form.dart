import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/work_sheet.dart';

class BreakTimeInputForm extends StatelessWidget {
  BreakTimeInputForm({
    super.key,
  });

  final WorkSheetProvider workSheetProvider = Get.put(WorkSheetProvider());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu(
          menuHeight: 200,
          initialSelection: 60,
          dropdownMenuEntries: List.generate(16, (index) {
            final minutes = (index + 1) * 30;
            final hours = minutes ~/ 60;
            final remainingMinutes = minutes % 60;
            final label = hours > 0 ? '$hours:${remainingMinutes.toString().padLeft(2, '0')}' : '$remainingMinutes';
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
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            workSheetProvider.breakTime();
            Get.back();
          },
          child: Text('workRefresh'.tr),
        ),
      ],
    );
  }
}
