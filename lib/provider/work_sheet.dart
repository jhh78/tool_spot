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
  RxList<WorkSheetModel> filteredData = <WorkSheetModel>[].obs;
  RxMap<String, List<WorkSheetModel>> events = <String, List<WorkSheetModel>>{}.obs;
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
    final List<Map<String, WorkSheetModel>> list = await workSheetHalper.getList();

    events.clear();
    for (Map<String, WorkSheetModel> item in list) {
      if (!events.containsKey(item.keys.first)) {
        events[item.keys.first] = [];
      }

      events[item.keys.first]!.add(item.values.first);
    }

    filteredData.clear();
    filteredData.addAll(
        list.where((element) => element.keys.first == convertLocaleDateFormat(selectedDay.value)).map((e) => e.values.first).toList());
  }

  Future<void> startWork() async {
    final DateTime now = DateTime.now();
    workSheetHalper
        .attendanceRecords(
      WorkSheetModel(
        kind: WORK_SHEET_KIND_START,
        date: convertLocaleDateTimeFormat(now),
        ymd: convertLocaleDateFormat(now),
        hms: convertLocaleTimeFormat(now),
      ),
    )
        .then((value) {
      onFetchCalenderData();
    }).catchError((e) async {
      Get.defaultDialog(
        title: 'error'.tr,
        content: Text("duplicateData".tr),
      );
    });
  }

  Future<void> endWork() async {
    final DateTime now = DateTime.now();
    workSheetHalper
        .attendanceRecords(
      WorkSheetModel(
        kind: WORK_SHEET_KIND_END,
        date: convertLocaleDateTimeFormat(now),
        ymd: convertLocaleDateFormat(now),
        hms: convertLocaleTimeFormat(now),
      ),
    )
        .then((value) {
      onFetchCalenderData();
    }).catchError((e) async {
      Get.defaultDialog(
        title: 'error'.tr,
        content: Text("duplicateData".tr),
      );
    });
  }

  Future<void> deleteItem(int id) async {
    await workSheetHalper.delete(id);
    onFetchCalenderData();
  }

  void onPageChanged(DateTime focusedDay) async {
    await onFetchCalenderData();
    this.focusedDay.value = focusedDay;
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final String ymd = convertLocaleDateFormat(selectedDay);
    this.selectedDay.value = selectedDay;

    filteredData.clear();
    filteredData.addAll(events[ymd] ?? []);
  }

  List<WorkSheetModel> eventLoader(DateTime day) {
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

  bool isToday() {
    return convertLocaleDateFormat(focusedDay.value) == convertLocaleDateFormat(selectedDay.value);
  }
}
