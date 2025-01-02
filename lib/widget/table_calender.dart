import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalenderWidget extends StatelessWidget {
  const TableCalenderWidget({
    super.key,
    required this.onPageChanged,
    required this.onDaySelected,
    required this.eventLoader,
    required this.focusedDay,
    required this.selectedDay,
    this.shouldFillViewport = false,
    this.calendarBuilders,
  });

  final Function(DateTime)? onPageChanged;
  final Function(DateTime, DateTime)? onDaySelected;
  final List<dynamic> Function(DateTime)? eventLoader;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final bool shouldFillViewport;
  final CalendarBuilders<dynamic>? calendarBuilders;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: DateTime(1990),
      lastDay: DateTime(2100),
      locale: Get.locale.toString(),
      shouldFillViewport: shouldFillViewport,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onPageChanged: onPageChanged,
      calendarBuilders: calendarBuilders ?? calendarBuilders!,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      eventLoader: eventLoader,
      onDaySelected: onDaySelected,
    );
  }
}
