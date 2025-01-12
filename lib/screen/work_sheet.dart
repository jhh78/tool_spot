import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/model/work_sheet.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/work_sheet.dart';
import 'package:life_secretary/util/constants.dart';
import 'package:life_secretary/util/util.dart';
import 'package:life_secretary/widget/table_calender.dart';
import 'package:life_secretary/widget/work_sheet/bottom_navigation_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkSheetScreen extends StatefulWidget {
  const WorkSheetScreen({super.key});

  @override
  State<WorkSheetScreen> createState() => _WorkSheetScreenState();
}

class _WorkSheetScreenState extends State<WorkSheetScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final SystemProvider systemProvider = Get.put(SystemProvider());
  final WorkSheetProvider workSheetProvider = Get.put(WorkSheetProvider());

  String getTitleText(WorkSheetViewModel param) {
    final kind = param.kind;

    if (kind == WORK_SHEET_KIND_START || kind == WORK_SHEET_KIND_END) {
      return 'workStart'.tr;
    } else if (kind == WORK_SHEET_KIND_REST) {
      return 'workRefresh'.tr;
    }

    return 'AAA';
  }

  Widget renderBottomNavigation() {
    if (workSheetProvider.isToday()) {
      return BottomNavigationBarWidget();
    }

    return const SizedBox.shrink();
  }

  Widget renderItemList() {
    if (workSheetProvider.filteredData.isEmpty) {
      return Center(
        child: Text('dataNotFound'.tr),
      );
    }

    return ListView.builder(
      itemCount: workSheetProvider.filteredData.length,
      itemBuilder: (BuildContext context, int index) {
        final headText = getTitleText(workSheetProvider.filteredData[index]);
        final themeColor = workSheetProvider.getEventColor(workSheetProvider.filteredData[index].kind);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: SPACE_SIZE_4, horizontal: SPACE_SIZE_8),
          padding: const EdgeInsets.all(SPACE_SIZE_8),
          decoration: BoxDecoration(
            color: themeColor.withAlpha(30),
            border: Border.all(color: themeColor),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: themeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.event,
                      color: Colors.white,
                      size: ICON_SIZE_12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    headText,
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    ),
                  ),
                ],
              ),
              Text(
                workSheetProvider.filteredData[index].kind == WORK_SHEET_KIND_REST
                    ? '${workSheetProvider.filteredData[index].value / 60} ${'timeSheetUnitHour'.tr}'
                    : convertLocaleTimeFormat(
                        DateTime.parse('${workSheetProvider.filteredData[index].ymd} ${workSheetProvider.filteredData[index].time}')),
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => TableCalenderWidget(
              onPageChanged: workSheetProvider.onPageChanged,
              onDaySelected: workSheetProvider.onDaySelected,
              eventLoader: workSheetProvider.eventLoader,
              focusedDay: workSheetProvider.focusedDay.value,
              selectedDay: workSheetProvider.selectedDay.value,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(SPACE_SIZE_1),
                              width: SPACE_SIZE_4,
                              height: SPACE_SIZE_8,
                              decoration: BoxDecoration(
                                color: workSheetProvider.getEventColor(events[index].kind),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Divider(),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          convertLocaleDateFormat(workSheetProvider.selectedDay.value),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            routerProvider.changeScreen(context, ROUTER_WORKSHEET_MODIFY);
                          },
                          icon: const Icon(
                            Icons.edit_calendar_outlined,
                            size: ICON_SIZE_28,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() => renderItemList()),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => renderBottomNavigation()),
    );
  }
}
