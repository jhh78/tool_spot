import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/db/work_sheet.dart';
import 'package:life_secretary/model/work_sheet.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/util/constants.dart';
import 'package:life_secretary/util/util.dart';

class WorkSheetProvider extends GetxController {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final WorkSheetHalper workSheetHalper = WorkSheetHalper();
  final Map<String, List<WorkSheetViewModel>> events = <String, List<WorkSheetViewModel>>{};

  RxList<WorkSheetViewModel> filteredData = <WorkSheetViewModel>[].obs;
  RxInt refreshTime = 0.obs;
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    routerProvider.workSheetFocusNode.addListener(_onFocusChange);
  }

  @override
  Future<void> dispose() async {
    routerProvider.workSheetFocusNode.removeListener(_onFocusChange);
    routerProvider.workSheetFocusNode.dispose();

    super.dispose();
  }

  void _onFocusChange() async {
    if (routerProvider.workSheetFocusNode.hasFocus) {
      await onFetchCalenderData();
    }
  }

  Future<void> onFetchCalenderData() async {
    final List<Map<String, WorkSheetModel>> list = await workSheetHalper.getList(focusedDay.value);

    events.clear();
    for (Map<String, WorkSheetModel> item in list) {
      if (!events.containsKey(item.keys.first)) {
        events[item.keys.first] = [];
      }

      if (item[item.keys.first]?.start_time != null) {
        events[item.keys.first]!.add(WorkSheetViewModel(
          ymd: item.keys.first,
          kind: WORK_SHEET_KIND_START,
          time: convertLocaleTimeFormat(DateTime.parse(item[item.keys.first]!.start_time)),
        ));
      }

      if (item[item.keys.first]?.end_time != null) {
        events[item.keys.first]!.add(WorkSheetViewModel(
          ymd: item.keys.first,
          kind: WORK_SHEET_KIND_END,
          time: convertLocaleTimeFormat(DateTime.parse(item[item.keys.first]!.end_time ?? '')),
        ));
      }
    }

    onDaySelected(selectedDay.value, focusedDay.value);
  }

  Future<void> startWork() async {
    try {
      await workSheetHalper.attendanceRecords();
      await onFetchCalenderData();
    } catch (e) {
      log('error: $e');
      Get.defaultDialog(
        title: 'error'.tr,
        content: Text("duplicateData".tr),
      );
    }
  }

  Future<void> endWork() async {
    try {
      await workSheetHalper.update();
      await onFetchCalenderData();
    } catch (e) {
      log('error: $e');
      Get.defaultDialog(
        title: 'error'.tr,
        content: Text(
          "workTimeUpdateFail".tr,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Future<void> deleteItem(int id) async {
    await workSheetHalper.delete(id);
    onFetchCalenderData();
  }

  void onPageChanged(DateTime focusedDay) async {
    await onFetchCalenderData();
    this.focusedDay.value = focusedDay;
    log('focusedDay: $focusedDay');
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final String ymd = convertLocaleDateFormat(selectedDay);
    this.selectedDay.value = selectedDay;
    final fData = events.entries.firstWhere((element) => element.key == ymd, orElse: () => MapEntry(ymd, [])).value;

    filteredData.clear();
    filteredData.addAll(fData);
  }

  List<WorkSheetViewModel> eventLoader(DateTime day) {
    if (!routerProvider.workSheetFocusNode.hasFocus) {
      return [];
    }

    final String ymd = convertLocaleDateFormat(day);
    return events[ymd] ?? [];
  }

  Color getEventColor(String kind) {
    if (kind == WORK_SHEET_KIND_START) {
      return Colors.green;
    } else if (kind == WORK_SHEET_KIND_END) {
      return Colors.red;
    } else if (kind == WORK_SHEET_KIND_REST) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  Future<void> breakTime() async {
    try {
      await workSheetHalper.breakTimeRecords(refreshTime.value);
      await onFetchCalenderData();
      refreshTime.value = 0;
    } catch (e) {
      log('error: $e');
      Get.defaultDialog(
        title: 'error'.tr,
        content: Text(
          "workTimeUpdateFail".tr,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  bool isToday() {
    return convertLocaleDateFormat(focusedDay.value) == convertLocaleDateFormat(selectedDay.value);
  }
}
