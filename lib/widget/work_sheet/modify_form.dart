import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/model/work_sheet.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/validate.dart';
import 'package:life_secretary/provider/work_sheet.dart';
import 'package:life_secretary/util/constants.dart';
import 'package:life_secretary/util/util.dart';
import 'package:life_secretary/widget/work_sheet/pats/dropdown_menu.dart';
import 'package:life_secretary/widget/work_sheet/pats/modify_form_add_item.dart';

const Map<String, dynamic> InitNewWorkData = {
  'kind': '',
  'h': -1,
  'm': -1,
};

class WorkSheetModifyScreen extends StatefulWidget {
  const WorkSheetModifyScreen({super.key});

  @override
  State<WorkSheetModifyScreen> createState() => WorkSheetModifyScreenState();
}

class WorkSheetModifyScreenState extends State<WorkSheetModifyScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final WorkSheetProvider workSheetProvider = Get.put(WorkSheetProvider());
  final ValidateProvider validateProvider = Get.put(ValidateProvider());
  final List<int> timeList = List.generate(23, (index) => index + 1);
  final List<int> minuteList = List.generate(60, (index) => index);
  final List<String> kindList = <String>['workStart'.tr, 'workEnd'.tr, 'workRefresh'.tr];
  List<WorkSheetViewModel> workSheetList = <WorkSheetViewModel>[];
  final Map<String, dynamic> newWorkData = Map.from(InitNewWorkData);
  bool isValidate = true;

  @override
  void initState() {
    super.initState();
    routerProvider.workSheetModifyFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    routerProvider.workSheetModifyFocusNode.removeListener(_onFocusChange);
    routerProvider.workSheetModifyFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (routerProvider.workSheetModifyFocusNode.hasFocus) {
      log('\t\t\t\t\t\t\t\t\t\t WorkSheet Modify screen has focus');
      validateProvider.setError(false);
      for (final item in workSheetProvider.filteredData) {
        item.uuid = UniqueKey().toString();
        workSheetList.add(item);
      }

      setState(() {});
    } else {
      workSheetList.clear();
    }
  }

  void reFetchDetailItems(String uuid) {
    log('>>>>>>>>>>>>>>>>>>>> uuid: $uuid');
    setState(() {
      workSheetList = workSheetList.where((element) => element.uuid != uuid).toList();
    });
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
              DropdownMenuWidget(list: timeList, initialSelection: h),
              const SizedBox(width: 10),
              DropdownMenuWidget(list: minuteList, initialSelection: m),
            ],
          ),
        ],
      ),
    );
  }

  Widget renderUpdateSubmit() {
    if (workSheetList.isEmpty) {
      return Expanded(
        child: Center(
          child: Text('dataNotFound'.tr),
        ),
      );
    }

    return InkWell(
      onTap: () {
        log('>>>>>>>>>>>>>>>>>>>> update button');
      },
      child: Container(
        padding: const EdgeInsets.all(SPACE_SIZE_12),
        margin: const EdgeInsets.all(SPACE_SIZE_16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Text("workTimeUpdateFormUpdate".tr),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  convertLocaleDateFormat(workSheetProvider.selectedDay.value),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: () {
                    newWorkData.clear();
                    validateProvider.error.value = false;

                    Get.bottomSheet(
                      ModifyFormAddItemWidget(
                        newWorkData: newWorkData,
                        kindList: kindList,
                        timeList: timeList,
                        minuteList: minuteList,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: ICON_SIZE_32,
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
          renderUpdateSubmit(),
        ],
      ),
    );
  }
}
