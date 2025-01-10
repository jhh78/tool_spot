import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalenderWidget extends StatelessWidget {
  final Function(DateTime)? onPageChanged;
  final Function(DateTime, DateTime)? onDaySelected;
  final List<dynamic> Function(DateTime)? eventLoader;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final bool shouldFillViewport;
  final CalendarBuilders<dynamic>? calendarBuilders;

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
      calendarBuilders: calendarBuilders ?? const CalendarBuilders(),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      eventLoader: eventLoader,
      onDaySelected: onDaySelected,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        weekendStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0], // 요일의 첫 글자만 표시
      ),
    );
  }
}
