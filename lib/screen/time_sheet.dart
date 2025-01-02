import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/widget/table_calender.dart';
import 'package:life_secretary/widget/work_sheet/bottom_navigation_bar.dart';
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
  DateTime _selectedDay = DateTime.now();

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

  void _onPageChanged(DateTime focusedDay) {
    log('>>>>>>>>>>>>>>>>>>>> focusedDay: $focusedDay');
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    log('>>>>>>>>>>>>>>>>>>>> selectedDay: $selectedDay, focusedDay: $focusedDay');

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  List<Map<String, dynamic>> _eventLoader(DateTime day) {
    log('>>>>>>>>>>>>>>>>>>>> day: $day');
    return [
      {
        'id': 1,
        'kind': 'start',
        'descript': '$day 출근',
        'time': '09:00',
      },
      {
        'id': 2,
        'kind': 'end',
        'descript': '$day 퇴근',
        'time': '18:00',
      },
      {
        'id': 3,
        'kind': 'refresh',
        'descript': '$day 휴식',
        'time': '1:00',
      },
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchData(DateTime day) async {
    log('>>>>>>>>>>>>>>>>>>>> _fetchData day: $day');

    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'id': 1,
        'kind': 'start',
        'descript': '$day 출근',
        'time': '09:00',
      },
      {
        'id': 2,
        'kind': 'end',
        'descript': '$day 퇴근',
        'time': '18:00',
      },
      {
        'id': 3,
        'kind': 'refresh',
        'descript': '$day 휴식',
        'time': '1:00',
      },
    ];
  }

  Color _getEventColor(Map<String, dynamic> event) {
    if (event['kind'] == 'start') {
      return Colors.green;
    } else if (event['kind'] == 'end') {
      return Colors.red;
    } else if (event['kind'] == 'refresh') {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TableCalenderWidget(
            onPageChanged: _onPageChanged,
            onDaySelected: _onDaySelected,
            eventLoader: _eventLoader,
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
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
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _getEventColor(events[index]),
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
          Expanded(
            child: FutureBuilder(
              future: _fetchData(_selectedDay),
              builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                return Scaffold(
                  body: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          snapshot.data![index]['descript'],
                          style: TextStyle(
                            color: _getEventColor(snapshot.data![index]),
                          ),
                        ),
                        subtitle: Text(
                          snapshot.data![index]['time'],
                          style: TextStyle(
                            color: _getEventColor(snapshot.data![index]),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                log('>>>>>>>>>>>>>>>>>>>> Edit button pressed');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                log('>>>>>>>>>>>>>>>>>>>> Delete button pressed');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
