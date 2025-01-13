import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:life_secretary/model/holiday.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/util/styles.dart';
import 'package:http/http.dart' as http;

class HolidayCalenderScreen extends StatefulWidget {
  const HolidayCalenderScreen({super.key});

  @override
  State<HolidayCalenderScreen> createState() => _HolidayCalenderScreenState();
}

class _HolidayCalenderScreenState extends State<HolidayCalenderScreen> {
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final SystemProvider systemProvider = Get.put(SystemProvider());

  final List<Map<String, String>> countryMenuEntries = [
    {'country': '🇺🇸', 'code': 'US'},
    {'country': '🇰🇷', 'code': 'KR'},
    {'country': '🇯🇵', 'code': 'JP'},
    {'country': '🇨🇳', 'code': 'CN'},
  ];
  String selectedCountry = '';
  bool isLoading = false;
  String currentYear = DateTime.now().year.toString();

  List<HolidayModel> holidayList = [];

  @override
  void initState() {
    super.initState();
    routerProvider.holidayCalenderFocusNode.addListener(_onFocusChange);
  }

  @override
  Future<void> dispose() async {
    routerProvider.holidayCalenderFocusNode.removeListener(_onFocusChange);
    routerProvider.holidayCalenderFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (routerProvider.qrReaderFocusNode.hasFocus) {
      log('\t\t\t\t\t\t\t\t\t\t Holiday Calender Focus');
    }
  }

  Color getSelectedColor(String code) {
    if (systemProvider.themeMode.value == ThemeMode.dark) {
      return selectedCountry == code ? Colors.white54 : Colors.transparent;
    }

    return selectedCountry == code ? Colors.black54 : Colors.transparent;
  }

  Widget renderItems() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (selectedCountry.isEmpty) {
      return Center(
        child: Text('holidayCalenderNeedCountry'.tr),
      );
    }

    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: SPACE_SIZE_24,
        );
      },
      itemCount: holidayList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(
            Icons.calendar_month_outlined,
            color: systemProvider.getSystemThemeColor(),
            size: ICON_SIZE_32,
          ),
          title: Text(
            holidayList[index].localName.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            holidayList[index].name.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Text(
            holidayList[index].date.toString(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );
      },
    );
  }

  Future<void> fetchHoliday() async {
    setState(() {
      isLoading = true;
    });

    final url = "${dotenv.env['HOLIDAY_API']}/$currentYear/$selectedCountry";
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    holidayList.clear();
    for (var holiday in json) {
      holidayList.add(HolidayModel.fromJson(holiday));
    }

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: countryMenuEntries.map((Map<String, String> item) {
              final String country = item['country'].toString();
              final String code = item['code'].toString();
              return InkWell(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: SPACE_SIZE_2,
                    bottom: SPACE_SIZE_2,
                    left: SPACE_SIZE_12,
                    right: SPACE_SIZE_12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SPACE_SIZE_8),
                    border: Border.all(
                      color: getSelectedColor(code),
                    ),
                  ),
                  child: Text(
                    country,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: FONT_SIZE_40,
                        ),
                  ),
                ),
                onTap: () async {
                  setState(() {
                    selectedCountry = code;
                    currentYear = DateTime.now().year.toString();
                  });

                  await fetchHoliday();
                },
              );
            }).toList(),
          ),
          if (holidayList.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: ICON_SIZE_24),
                      onPressed: () async {
                        final int year = int.parse(currentYear);
                        setState(() {
                          currentYear = (year - 1).toString();
                        });

                        await fetchHoliday();
                      },
                    ),
                    Text(
                      currentYear,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: ICON_SIZE_24),
                      onPressed: () async {
                        final int year = int.parse(currentYear);
                        setState(() {
                          currentYear = (year + 1).toString();
                        });

                        await fetchHoliday();
                      },
                    ),
                  ],
                ),
              ],
            ),
          const Divider(
            height: SPACE_SIZE_8,
          ),
          Expanded(
            child: renderItems(),
          ),
        ],
      ),
    );
  }
}
