import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String ROUTER_HOME = 'menu';
const String ROUTER_QRREADER = 'qrReader';
const String ROUTER_ADDRESSTRANSLATE = 'addressTranslate';
const String ROUTER_HOLIDAY_CALENDER = 'holidayCalender';
const String ROUTER_ZIPCODE_SEARCH = 'zipcodeSearch';
const String ROUTER_ALARM = 'alarm';
const String ROUTER_PICTURE_TO_PDF = 'pdfConverter';

class RouterProvider extends GetxService {
  RxInt screenIndex = 0.obs;
  RxString currentScreen = ROUTER_HOME.obs;

  final FocusNode homeFocusNode = FocusNode();
  final FocusNode addressTranslateFocusNode = FocusNode();
  final FocusNode qrReaderFocusNode = FocusNode();
  final FocusNode holidayCalenderFocusNode = FocusNode();
  final FocusNode zipcodeSearchFocusNode = FocusNode();
  final FocusNode alarmFocusNode = FocusNode();
  final FocusNode pictureToPdfFocusNode = FocusNode();

  void changeScreen(BuildContext context, String screen) {
    currentScreen.value = screen;
    log('\t\t\t\t\t\t\t\t\t\t currentScreen: ${currentScreen.value}');

    if (screen == ROUTER_HOME) {
      FocusScope.of(context).requestFocus(homeFocusNode);
    } else if (screen == ROUTER_QRREADER) {
      FocusScope.of(context).requestFocus(qrReaderFocusNode);
    } else if (screen == ROUTER_ADDRESSTRANSLATE) {
      FocusScope.of(context).requestFocus(addressTranslateFocusNode);
    } else if (screen == ROUTER_HOLIDAY_CALENDER) {
      FocusScope.of(context).requestFocus(holidayCalenderFocusNode);
    } else if (screen == ROUTER_ZIPCODE_SEARCH) {
      FocusScope.of(context).requestFocus(zipcodeSearchFocusNode);
    } else if (screen == ROUTER_ALARM) {
      FocusScope.of(context).requestFocus(homeFocusNode);
    } else if (screen == ROUTER_PICTURE_TO_PDF) {
      FocusScope.of(context).requestFocus(pictureToPdfFocusNode);
    }
  }

  String getAppBarTitle() {
    if (currentScreen.value == ROUTER_HOME) {
      return "mainHomeTitle".tr;
    } else if (currentScreen.value == ROUTER_QRREADER) {
      return "qrReaderTitle".tr;
    } else if (currentScreen.value == ROUTER_ADDRESSTRANSLATE) {
      return "addressTranslate".tr;
    } else if (currentScreen.value == ROUTER_HOLIDAY_CALENDER) {
      return "holidayCalenderTitle".tr;
    } else if (currentScreen.value == ROUTER_ZIPCODE_SEARCH) {
      return "zipcodeSearchTitle".tr;
    } else if (currentScreen.value == ROUTER_ALARM) {
      return "alarmTitle".tr;
    }

    return "---";
  }
}
