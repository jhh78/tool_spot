import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/util/constants.dart';

class RouterProvider extends GetxService {
  RxInt screenIndex = 0.obs;
  RxString currentScreen = ROUTER_HOME.obs;

  final FocusNode homeFocusNode = FocusNode();
  final FocusNode addressTranslateFocusNode = FocusNode();
  final FocusNode qrReaderFocusNode = FocusNode();

  final FocusNode workSheetFocusNode = FocusNode();
  final FocusNode workSheetModifyFocusNode = FocusNode();

  void changeScreen(BuildContext context, String screen) {
    currentScreen.value = screen;
    log('\t\t\t\t\t\t\t\t\t\t currentScreen: ${currentScreen.value}');

    if (screen == ROUTER_HOME) {
      FocusScope.of(context).requestFocus(homeFocusNode);
    } else if (screen == ROUTER_QRREADER) {
      FocusScope.of(context).requestFocus(qrReaderFocusNode);
    } else if (screen == ROUTER_ADDRESSTRANSLATE) {
      FocusScope.of(context).requestFocus(addressTranslateFocusNode);
    } else if (screen == ROUTER_WORKSHEET) {
      FocusScope.of(context).requestFocus(workSheetFocusNode);
    } else if (screen == ROUTER_WORKSHEET_MODIFY) {
      FocusScope.of(context).requestFocus(workSheetModifyFocusNode);
    }
  }

  String getAppBarTitle() {
    if (currentScreen.value == ROUTER_HOME) {
      return "mainHomeTitle".tr;
    } else if (currentScreen.value == ROUTER_QRREADER) {
      return "qrReaderTitle".tr;
    } else if (currentScreen.value == ROUTER_ADDRESSTRANSLATE) {
      return "addressTranslate".tr;
    } else if (currentScreen.value == ROUTER_WORKSHEET) {
      return "timeSheet".tr;
    } else if (currentScreen.value == ROUTER_WORKSHEET_MODIFY) {
      return "workSummary".tr;
    }

    return "---";
  }
}
