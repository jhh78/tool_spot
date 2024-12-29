import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/vender/ad.dart';
import 'package:life_secretary/util/constants.dart';
import 'package:life_secretary/widget/address_translate_history.dart';
import 'package:life_secretary/widget/button/action.dart';

class AddressTranslate extends StatefulWidget {
  const AddressTranslate({super.key});

  @override
  State<AddressTranslate> createState() => _AddressTranslateState();
}

class _AddressTranslateState extends State<AddressTranslate> {
  final SystemProvider systemProvider = Get.put(SystemProvider());
  final ADManager adManager = Get.put(ADManager());
  final TextEditingController _addressController = TextEditingController();
  final RouterProvider routerProvider = Get.put(RouterProvider());

  void handleTryTranslate() {
    log('Translate');
    if (systemProvider.point.value < ADDRESS_TRANSLATE_DECREMENT_POINT) {
      Get.defaultDialog(
        radius: 5,
        title: 'lackPoints'.tr,
        titleStyle: Theme.of(context).textTheme.titleMedium,
        content: ActionButtonWidget(
          onPressed: () async {
            Get.back();
            adManager.loadRewardAd();
          },
          middleText: 'showAdDescription'.tr,
          buttonText: 'showAd'.tr,
        ),
      );
      return;
    }

    // TODO: AI Translate address
    systemProvider.decrementPoint(ADDRESS_TRANSLATE_DECREMENT_POINT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {},
                label: Obx(() => Text(
                      systemProvider.point.value.toString(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    )),
                icon: const Icon(
                  Icons.payments_outlined,
                  size: ICON_SIZE,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'menuTitle'.tr,
                    content: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            routerProvider.moveQRReader();
                            Get.back();
                          },
                          child: Text('qrReaderTitle'.tr),
                        ),
                        TextButton(
                          onPressed: () {
                            routerProvider.moveAddressTranslate();
                            Get.back();
                          },
                          child: Text('addressTranslate'.tr),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.list_alt, size: ICON_SIZE),
              )
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _addressController,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: 5,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                        labelText: 'Address'.tr,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: ActionButtonWidget(
                      onPressed: handleTryTranslate,
                      buttonText: 'translateButton'.tr,
                    ),
                  ),
                  const Expanded(child: AddressTranslateHistoryWidget()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
