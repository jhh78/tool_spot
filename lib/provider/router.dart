import 'package:get/get.dart';

class RouterProvider extends GetxService {
  RxInt screenIndex = 0.obs;

  void moveHome() => screenIndex.value = 0;
  void moveQRReader() => screenIndex.value = 1;
  void moveAddressTranslate() => screenIndex.value = 2;
}
