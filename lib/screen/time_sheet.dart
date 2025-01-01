import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/util/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final SystemProvider systemProvider = Get.put(SystemProvider());
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    routerProvider.timeSheetFocusNode.addListener(_onFocusChange);
  }

  @override
  Future<void> dispose() async {
    routerProvider.timeSheetFocusNode.removeListener(_onFocusChange);
    routerProvider.timeSheetFocusNode.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    if (routerProvider.timeSheetFocusNode.hasFocus) {
      log('>>>>>>>>>>>>>>>>>>>> TimeSheetScreen screen has focus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2100),
            locale: Get.locale.toString(),
            onPageChanged: (focusedDay) {
              log('>>>>>>>>>>>>>>>>>>>> focusedDay: $focusedDay');
            },
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            eventLoader: (day) {
              return [1, 2, 3];
            },
            onDaySelected: (selectedDay, focusedDay) {
              log('>>>>>>>>>>>>>>>>>>>> selectedDay: $selectedDay, focusedDay: $focusedDay');
              setState(() {
                _focusedDay = focusedDay;
              });
              Get.defaultDialog(
                title: '근태기록',
                content: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '날짜: ${selectedDay.toLocal()}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '근무 시간: 9:00 AM - 6:00 PM',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '휴식 시간: 1:00 PM - 2:00 PM',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '총 근무 시간: 8시간',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Change the state to show input fields
                          });
                        },
                        child: Text('수정'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: ListTile(
                    title: Text('근태기록 $index'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle: TextStyle(color: systemProvider.getSystemThemeColor()),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                size: ICON_SIZE,
                Icons.upload_outlined,
                color: systemProvider.getSystemThemeColor(),
              ),
              label: '출근',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: ICON_SIZE,
                Icons.download_outlined,
                color: systemProvider.getSystemThemeColor(),
              ),
              label: '퇴근',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: ICON_SIZE,
                Icons.local_cafe_outlined,
                color: systemProvider.getSystemThemeColor(),
              ),
              label: '휴식',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                size: ICON_SIZE,
                Icons.auto_graph_outlined,
                color: systemProvider.getSystemThemeColor(),
              ),
              label: '통계',
            ),
          ],
          onTap: (index) {
            log('>>>>>>>>>>>>>>>>>>>> index: $index');
          },
        ),
      ),
    );
  }
}
