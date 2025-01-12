import 'package:get/get.dart';

class ValidateProvider extends GetxController {
  final RxBool error = false.obs;

  setError(bool value) {
    error.value = value;
  }
}
