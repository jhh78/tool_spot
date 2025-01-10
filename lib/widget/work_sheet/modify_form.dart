import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/model/work_sheet.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/work_sheet.dart';
import 'package:life_secretary/util/constants.dart';

class WorkSheetModifyScreen extends StatefulWidget {
  const WorkSheetModifyScreen({
    super.key,
    required this.changeScreen,
  });

  final Function(int index) changeScreen;

  @override
  State<WorkSheetModifyScreen> createState() => WorkSheetModifyScreenState();
}

class WorkSheetModifyScreenState extends State<WorkSheetModifyScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final WorkSheetProvider workSheetProvider = Get.put(WorkSheetProvider());
  final List<int> timeList = List.generate(23, (index) => index + 1);
  final List<int> minuteList = List.generate(60, (index) => index);
  final List<String> kindList = <String>['workStart'.tr, 'workEnd'.tr, 'workRefresh'.tr];
  List<WorkSheetViewModel> workSheetList = <WorkSheetViewModel>[];
  Map<String, dynamic> newWorkData = <String, dynamic>{
    'kind': '',
    'h': '',
    'm': '',
  };

  @override
  void initState() {
    super.initState();
    routerProvider.workSheetModifyFocusNode.addListener(_onFocusChange);
    for (final item in workSheetProvider.filteredData) {
      item.uuid = UniqueKey().toString();
      workSheetList.add(item);
    }
  }

  @override
  void dispose() {
    widget.changeScreen(0);
    super.dispose();
  }

  void _onFocusChange() {
    if (routerProvider.workSheetModifyFocusNode.hasFocus) {
      log('>>>>>>>>>>>>>>>>>>>> AddressTranslate screen has focus');
    } else {
      log('>>>>>>>>>>>>>>>>>>>> AddressTranslate screen has no focus');
    }
  }

  void reFetchDetailItems(String uuid) {
    log('>>>>>>>>>>>>>>>>>>>> uuid: $uuid');
    setState(() {
      workSheetList = workSheetList.where((element) => element.uuid != uuid).toList();
    });
  }

  DropdownMenu<int> renderDropDownMenu<T>({required List<T> list, int? initialSelection, String? helperText}) {
    return DropdownMenu(
      menuHeight: DROPDOWN_MENU_ITEM_HEIGHT,
      width: 100,
      initialSelection: initialSelection,
      helperText: helperText,
      textAlign: TextAlign.center,
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
                  menuHeight: DROPDOWN_MENU_ITEM_HEIGHT,
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

    final h = DateTime.parse(item.sortTime.toString()).toLocal().hour - 1;
    final m = DateTime.parse(item.sortTime.toString()).toLocal().minute;

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
              renderDropDownMenu<int>(list: timeList, initialSelection: h),
              const SizedBox(width: 10),
              renderDropDownMenu<int>(list: minuteList, initialSelection: m),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "9999-99-99",
                        style: Theme.of(context).textTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
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
                        height: 300,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'workTimeAddNewItem'.tr,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  renderDropDownMenu<String>(list: kindList, helperText: 'workTimeAddNewItemKind'.tr),
                                  const SizedBox(width: 10),
                                  renderDropDownMenu<int>(list: timeList, helperText: 'workTimeAddNewItemHour'.tr),
                                  const SizedBox(width: 10),
                                  renderDropDownMenu<int>(list: minuteList, helperText: 'workTimeAddNewItemMinute'.tr),
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
