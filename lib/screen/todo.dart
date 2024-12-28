import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:life_secretary/model/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting(Get.deviceLocale?.toString() ?? 'en_US', null).then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todoTitle'.tr),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TableCalendar(
                  shouldFillViewport: true,
                  availableGestures: AvailableGestures.none,
                  firstDay: DateTime.utc(1900, 1, 1),
                  lastDay: DateTime.utc(9999, 12, 31),
                  locale: Get.deviceLocale?.toString() ?? 'en_US',
                  focusedDay: _focusedDay,
                  eventLoader: (day) {
                    return [
                      const Event('Event 1'),
                    ];
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    log('Selected: $selectedDay');
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onDayLongPressed: (selectedDay, focusedDay) {
                    log('Long pressed: $selectedDay');
                  },
                  onPageChanged: (focusedDay) {
                    log('Page changed: $focusedDay');
                    _focusedDay = focusedDay;
                  },
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
            child: Container(
          color: Colors.grey.withAlpha(50),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeCap: StrokeCap.round,
              strokeWidth: 15,
            ),
          ),
        )),
      ]),
    );
  }
}
