import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/db/work_sheet.dart';
import 'package:life_secretary/model/break_time.dart';
import 'package:life_secretary/model/work_sheet.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/util/constants.dart';
import 'package:life_secretary/util/util.dart';

class WorkSheetProvider extends GetxController {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final WorkSheetHalper workSheetHalper = WorkSheetHalper();

  RxMap<String, List<WorkSheetViewModel>> events = <String, List<WorkSheetViewModel>>{}.obs;
  RxList<WorkSheetViewModel> filteredData = <WorkSheetViewModel>[].obs;
  RxInt refreshTime = 60.obs;
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

    for (Map<String, WorkSheetModel> item in list) {
      if (!events.containsKey(item.keys.first)) {
        events[item.keys.first] = [];
      }

      if (item[item.keys.first]?.start_time != null) {
        events[item.keys.first]!.add(WorkSheetViewModel(
          id: item[item.keys.first]!.id.toString(),
          sortTime: DateTime.parse(item[item.keys.first]!.start_time),
          ymd: item.keys.first,
          kind: WORK_SHEET_KIND_START,
          time: convertLocaleTimeFormat(DateTime.parse(item[item.keys.first]!.start_time)),
        ));
      }

      if (item[item.keys.first]?.end_time != null) {
        events[item.keys.first]!.add(WorkSheetViewModel(
          id: item[item.keys.first]!.id.toString(),
          sortTime: DateTime.parse(item[item.keys.first]!.end_time!),
          ymd: item.keys.first,
          kind: WORK_SHEET_KIND_END,
          time: convertLocaleTimeFormat(DateTime.parse(item[item.keys.first]!.end_time ?? '')),
        ));
      }

      if (item[item.keys.first]?.breakTime != null) {
        for (BreakTimeModel breakTime in item[item.keys.first]!.breakTime!) {
          events[item.keys.first]!.add(WorkSheetViewModel(
            id: breakTime.id.toString(),
            sortTime: DateTime.parse(breakTime.start_time),
            ymd: item.keys.first,
            kind: WORK_SHEET_KIND_REST,
            time: convertLocaleTimeFormat(DateTime.parse(breakTime.start_time)),
            start_time: convertLocaleTimeFormat(DateTime.parse(breakTime.start_time)),
            end_time: convertLocaleTimeFormat(DateTime.parse(breakTime.end_time)),
            value: breakTime.value,
          ));
        }
      }

      // 중복 제거
      final Map<String, WorkSheetViewModel> uniqueEvents = {};
      for (var event in events[item.keys.first]!) {
        if (event.kind == WORK_SHEET_KIND_REST) {
          uniqueEvents[event.start_time.toString()] = event;
        } else {
          uniqueEvents[event.kind] = event;
        }
      }
      events[item.keys.first] = uniqueEvents.values.toList();
      events[item.keys.first]!.sort((a, b) => a.sortTime.compareTo(b.sortTime));
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
      onFetchCalenderData();
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

  Future<void> deleteBreakTimeItem(String id) async {
    await workSheetHalper.deleteBreakTimeItem(id);
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
    this.focusedDay.value = focusedDay;
    final fData = events.entries.firstWhere((element) => element.key == ymd, orElse: () => MapEntry(ymd, [])).value;

    filteredData.clear();
    filteredData.addAll(fData);
  }

  List<WorkSheetViewModel> eventLoader(DateTime day) {
    if (!routerProvider.workSheetFocusNode.hasFocus) {
      return [];
    }

    final String ymd = convertLocaleDateFormat(day);
    log('>>>>>>>>>>>>>>>>>>>> ymd: $ymd events[ymd]: ${events[ymd]}');
    return events[ymd] ?? [];
  }

  Color getEventColor(String kind) {
    if (kind == WORK_SHEET_KIND_START) {
      return Colors.blueAccent;
    } else if (kind == WORK_SHEET_KIND_END) {
      return Colors.redAccent;
    } else if (kind == WORK_SHEET_KIND_REST) {
      return Colors.blueGrey;
    } else {
      return Colors.grey;
    }
  }

  Future<void> breakTime() async {
    try {
      await workSheetHalper.breakTimeRecords(refreshTime.value);
      await onFetchCalenderData();
      refreshTime.value = 60;
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
    return convertLocaleDateFormat(DateTime.now()) == convertLocaleDateFormat(focusedDay.value);
  }
}
