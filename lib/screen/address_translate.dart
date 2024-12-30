import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_secretary/db/address_converter.dart';
import 'package:life_secretary/model/address_converter.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/vender/ad.dart';
import 'package:life_secretary/provider/vender/open_ai.dart';
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
  final OpenAIProvider openAIProvider = Get.put(OpenAIProvider());
  final ADManager adManager = Get.put(ADManager());
  final TextEditingController _addressController = TextEditingController();
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final AddressConverterHelper addressConverterHelper = AddressConverterHelper();
  final List<AddressConverterModel> addressConverterList = [];

  bool isTranslating = false;
  bool isFocused = false;
  String translatedAddress = '';
  String originalAddress = '';

  @override
  void initState() {
    super.initState();
    routerProvider.addressTranslateFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    routerProvider.addressTranslateFocusNode.removeListener(_onFocusChange);
    routerProvider.addressTranslateFocusNode.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (routerProvider.addressTranslateFocusNode.hasFocus) {
      log('AddressTranslate screen has focus');
      loadAddressConverter();
    }
  }

  void loadAddressConverter() async {
    final list = await addressConverterHelper.select();
    addressConverterList.clear();
    addressConverterList.addAll(list.map((e) => AddressConverterModel.fromMap(e)).toList());
    _addressController.clear();
    translatedAddress = '';
    setState(() {});
  }

  void deleteAddressConverter(int id) async {
    await addressConverterHelper.delete(id);
    loadAddressConverter();
  }

  void handleTryTranslate() {
    log('Translate');
    // if (systemProvider.point.value < ADDRESS_TRANSLATE_DECREMENT_POINT) {
    //   Get.defaultDialog(
    //     radius: 5,
    //     title: 'lackPoints'.tr,
    //     titleStyle: Theme.of(context).textTheme.titleMedium,
    //     content: ActionButtonWidget(
    //       onPressed: () async {
    //         Get.back();
    //         adManager.loadRewardAd();
    //       },
    //       middleText: 'showAdDescription'.tr,
    //       buttonText: 'showAd'.tr,
    //     ),
    //   );
    //   return;
    // }

    _sendToOpenAI();
  }

// asst_O9fBVFkYMvsuBKZcLJrqT7w8
  Future<void> _sendToOpenAI() async {
    try {
      if (_addressController.text.isEmpty) {
        throw Exception('addressEmpty'.tr);
      }

      FocusScope.of(context).unfocus();

      setState(() {
        isTranslating = true;
      });

      final response = await openAIProvider.translate(_addressController.text);
      systemProvider.decrementPoint(ADDRESS_TRANSLATE_DECREMENT_POINT);

      setState(() {
        isTranslating = false;
        originalAddress = _addressController.text;
        translatedAddress = response;
      });

      log(response);
    } catch (e) {
      Get.defaultDialog(
        title: 'error'.tr,
        content: Text(e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () {},
            label: Obx(() => Text(
                  systemProvider.point.value.toString(),
                  style: Theme.of(context).textTheme.headlineLarge,
                )),
            icon: Icon(
              Icons.payments_outlined,
              size: ICON_SIZE,
              color: Get.isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      readOnly: isTranslating,
                      style: TextStyle(
                        backgroundColor: isTranslating ? Colors.grey[300] : Colors.transparent,
                      ),
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
                  if (translatedAddress.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 12, left: 12, bottom: 12),
                      child: ListTile(
                        tileColor: Colors.lightBlue[100],
                        title: Text(translatedAddress),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                addressConverterHelper.insert(
                                  AddressConverterModel(address: translatedAddress).toMap(),
                                );

                                loadAddressConverter();
                                setState(() {
                                  translatedAddress = '';
                                  _addressController.text = '';
                                });
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: translatedAddress),
                                );

                                Get.snackbar('Copied', translatedAddress);
                              },
                              icon: const Icon(Icons.copy),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: isTranslating
                        ? const LinearProgressIndicator()
                        : ActionButtonWidget(
                            onPressed: handleTryTranslate,
                            buttonText: 'translateButton'.tr,
                          ),
                  ),
                  Expanded(
                      child: AddressTranslateHistoryWidget(
                    list: addressConverterList,
                    onDelete: deleteAddressConverter,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
