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
  final List<int> timeList = List.generate(23, (index) => index + 1);
  final List<int> minuteList = List.generate(60, (index) => index);
  final List<String> kindList = <String>['workStart'.tr, 'workEnd'.tr, 'workRefresh'.tr];
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

  DropdownMenu<int> renderDropDownMenu<T>(List<T> list) {
    return DropdownMenu(
      menuHeight: 200,
      width: 100,
      textAlign: TextAlign.center,
      initialSelection: 9,
      dropdownMenuEntries: List.generate(list.length, (index) {
        return DropdownMenuEntry(
          label: list[index].toString(),
          value: index,
        );
      }),
      onSelected: (value) {
        log('>>>>>>>>>>>>>>>>>>>> value: $value');
        // workSheetProvider.breakTimeValue.value = value!;
      },
    );
  }

  Widget renderFormItems(BuildContext context, WorkSheetViewModel item) {
    if (item.kind == WORK_SHEET_KIND_REST) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 24, right: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'workRefresh'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 24, right: MediaQuery.of(context).size.width * 0.175),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item.kind == WORK_SHEET_KIND_START
              ? Text(
                  'workStart'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              : Text(
                  'workEnd'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.135),
              renderDropDownMenu<int>(timeList),
              const SizedBox(width: 10),
              renderDropDownMenu<int>(minuteList),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('workTimeUpdateFormUpdate'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        height: 250,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text('workRefreshTimeSetting'.tr),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  renderDropDownMenu<String>(kindList),
                                  renderDropDownMenu<int>(timeList),
                                  const SizedBox(width: 10),
                                  renderDropDownMenu<int>(minuteList),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Text("workTimeUpdateFormUpdate".tr),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: ICON_SIZE,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: workSheetList.map((item) {
              return renderFormItems(context, item);
            }).toList(),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              log('>>>>>>>>>>>>>>>>>>>> update button');
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Text("workTimeUpdateFormUpdate".tr),
            ),
          ),
        ],
      ),
    );
  }
}
