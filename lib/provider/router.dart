import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouterProvider extends GetxService {
  RxInt screenIndex = 0.obs;

  final FocusNode homeFocusNode = FocusNode();
  final FocusNode addressTranslateFocusNode = FocusNode();
  final FocusNode qrReaderFocusNode = FocusNode();

  void moveHome(BuildContext context) {
    screenIndex.value = 0;
    FocusScope.of(context).requestFocus(homeFocusNode);
  }

  void moveQRReader(BuildContext context) {
    screenIndex.value = 1;
    FocusScope.of(context).requestFocus(qrReaderFocusNode);
  }

  void moveAddressTranslate(BuildContext context) {
    screenIndex.value = 2;
    FocusScope.of(context).requestFocus(addressTranslateFocusNode);
  }
}
