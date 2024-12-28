import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';

class AddressTranslate extends StatefulWidget {
  const AddressTranslate({super.key});

  @override
  State<AddressTranslate> createState() => _AddressTranslateState();
}

class _AddressTranslateState extends State<AddressTranslate> {
  final SystemProvider systemProvider = Get.put(SystemProvider());
  final TextEditingController _addressController = TextEditingController();
  final RouterProvider routerProvider = Get.put(RouterProvider());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  label: Obx(() => Text(
                        '${systemProvider.point.value}pt',
                        style: Theme.of(context).textTheme.headlineLarge,
                      )),
                  icon: const Icon(Icons.wallet, size: 40),
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
                  icon: const Icon(Icons.list_alt, size: 40),
                )
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
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
            ),
          ),
        ],
      ),
    );
  }
}
