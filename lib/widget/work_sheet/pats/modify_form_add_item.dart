import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/validate.dart';
import 'package:life_secretary/util/constants.dart';
import 'package:life_secretary/widget/work_sheet/pats/dropdown_menu.dart';

class ModifyFormAddItemWidget extends StatelessWidget {
  ModifyFormAddItemWidget({
    super.key,
    required this.newWorkData,
    required this.timeList,
    required this.minuteList,
    required this.kindList,
  });

  final ValidateProvider validateProvider = Get.put(ValidateProvider());
  final Map<String, dynamic> newWorkData;
  final List<int> timeList;
  final List<int> minuteList;
  final List<String> kindList;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: 300,
        child: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'workTimeAddNewItem'.tr,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownMenuWidget(list: kindList, helperText: 'workTimeAddNewItemKind'.tr),
                    const SizedBox(width: 10),
                    DropdownMenuWidget(list: timeList, helperText: 'workTimeAddNewItemHour'.tr),
                    const SizedBox(width: 10),
                    DropdownMenuWidget(list: minuteList, helperText: 'workTimeAddNewItemMinute'.tr),
                  ],
                ),
              ),
              Text(
                validateProvider.error.value ? 'requiredData'.tr : '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
              InkWell(
                onTap: () {
                  if (newWorkData.isEmpty) {
                    log('>>>>>>>>>>>>>>>>>>>> add button ${newWorkData.toString()}');
                    validateProvider.setError(true);
                    return;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(SPACE_SIZE_12),
                  margin: const EdgeInsets.all(SPACE_SIZE_16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text("workTimeUpdateFormUpdate".tr),
                ),
              )
            ],
          ),
        ));
  }
}
