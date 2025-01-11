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

class WorkSheetHomeScreen extends StatefulWidget {
  const WorkSheetHomeScreen({super.key, required this.changeScreen});
  final Function(int index) changeScreen;

  @override
  State<WorkSheetHomeScreen> createState() => _WorkSheetHomeScreenState();
}

class _WorkSheetHomeScreenState extends State<WorkSheetHomeScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final SystemProvider systemProvider = Get.put(SystemProvider());
  final WorkSheetProvider workSheetProvider = Get.put(WorkSheetProvider());

  String getTitleText(WorkSheetViewModel param) {
    final kind = param.kind;
    final time = param.time;
    String title = '';
    if (kind == WORK_SHEET_KIND_START) {
      title = 'workStart'.tr;
    } else if (kind == WORK_SHEET_KIND_END) {
      title = 'workEnd'.tr;
    } else if (kind == WORK_SHEET_KIND_REST) {
      title = 'workRefresh'.tr;
    }

    return '$title $time';
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
        child: Text('noData'.tr),
      );
    }

    return ListView.builder(
      itemCount: workSheetProvider.filteredData.length,
      itemBuilder: (BuildContext context, int index) {
        final headText = getTitleText(workSheetProvider.filteredData[index]);
        final themeColor = workSheetProvider.getEventColor(workSheetProvider.filteredData[index].kind);

        if (workSheetProvider.filteredData[index].kind == WORK_SHEET_KIND_REST) {
          return ListTile(
            title: Text(
              '$headText ~ ${workSheetProvider.filteredData[index].end_time}',
              style: TextStyle(
                color: themeColor,
              ),
            ),
          );
        }

        return ListTile(
          title: Text(
            headText,
            style: TextStyle(
              color: themeColor,
            ),
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
                              margin: const EdgeInsets.all(2),
                              width: 5,
                              height: 10,
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
                            icon: const Icon(Icons.edit_calendar_outlined))
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
