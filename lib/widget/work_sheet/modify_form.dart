import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/model/work_sheet.dart';
import 'package:life_secretary/provider/work_sheet.dart';
import 'package:life_secretary/util/constants.dart';

class WorkSheetModifyForm extends StatefulWidget {
  const WorkSheetModifyForm({
    super.key,
  });

  @override
  State<WorkSheetModifyForm> createState() => WorkSheetModifyFormState();
}

class WorkSheetModifyFormState extends State<WorkSheetModifyForm> {
  final WorkSheetProvider workSheetProvider = Get.put(WorkSheetProvider());
  List<WorkSheetViewModel> workSheetList = <WorkSheetViewModel>[];

  @override
  void initState() {
    super.initState();
    for (final item in workSheetProvider.filteredData) {
      item.uuid = UniqueKey().toString();
      workSheetList.add(item);
    }
  }

  void reFetchDetailItems(String uuid) {
    log('>>>>>>>>>>>>>>>>>>>> uuid: $uuid');
    setState(() {
      workSheetList = workSheetList.where((element) => element.uuid != uuid).toList();
    });
  }

  DropdownButton renderDropDownMenu(int range) {
    return DropdownButton<int>(
      value: 9,
      items: List.generate(range, (index) {
        return DropdownMenuItem<int>(
          value: index + 1,
          child: Text((index + 1).toString()),
        );
      }),
      onChanged: (value) {
        log('>>>>>>>>>>>>>>>>>>>> value: $value');
        // workSheetProvider.breakTimeValue.value = value!;
      },
    );
  }

  Padding renderFormItems(WorkSheetViewModel item) {
    if (item.kind == WORK_SHEET_KIND_REST) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('workRefresh'.tr),
            Row(
              children: [
                DropdownMenu(
                  menuHeight: 200,
                  initialSelection: item.value,
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
                IconButton(
                    onPressed: () async {
                      log('>>>>>>>>>>>>>>>>>>>> remove button');
                      reFetchDetailItems(item.uuid.toString());
                    },
                    icon: const Icon(Icons.remove_circle_outline))
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          item.kind == WORK_SHEET_KIND_START ? Text('workStart'.tr) : Text('workEnd'.tr),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.135),
              renderDropDownMenu(23),
              const Text('H'),
              const SizedBox(width: 10),
              renderDropDownMenu(59),
              const Text('M'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: workSheetList.map((item) {
            return renderFormItems(item);
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                log('>>>>>>>>>>>>>>>>>>>> update button');
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Text("workTimeUpdateFormUpdate".tr),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
