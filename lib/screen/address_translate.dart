import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:life_secretary/db/address_converter.dart';
import 'package:life_secretary/model/address_converter.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/provider/vender/ad.dart';
import 'package:life_secretary/provider/vender/open_ai.dart';
import 'package:life_secretary/util/constants.dart';
import 'package:life_secretary/util/util.dart';
import 'package:life_secretary/widget/address_translate_history.dart';
import 'package:life_secretary/widget/button/action.dart';

class AddressTranslate extends StatefulWidget {
  const AddressTranslate({super.key});

  @override
  State<AddressTranslate> createState() => _AddressTranslateState();
}

class _AddressTranslateState extends State<AddressTranslate> {
  final SystemProvider systemProvider = Get.put(SystemProvider());
  final OpenAiAndAssistantsProvider openAIProvider = OpenAiAndAssistantsProvider(
    apiKey: dotenv.env['OPENAI_ADDRESS_TRANSLATE_API_KEY'].toString(),
    assistantId: dotenv.env['OPENAI_ADDRESS_TRANSLATE_ASSISTANT_ID'].toString(),
  );
  final ADManager adManager = Get.put(ADManager());
  final TextEditingController _addressController = TextEditingController();
  final RouterProvider routerProvider = Get.put(RouterProvider());
  final AddressConverterHelper addressConverterHelper = AddressConverterHelper();
  final List<AddressConverterModel> addressConverterList = [];

  bool isTranslating = false;
  bool isFocused = false;
  String translatedAddress = '';

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
      log('\t\t\t\t\t\t\t\t\t\t AddressTranslate screen has focus');
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

  void handleTryTranslate(BuildContext context) {
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

    _sendToOpenAI(context);
  }

  Future<void> _sendToOpenAI(BuildContext context) async {
    try {
      if (_addressController.text.isEmpty) {
        throw Exception('requiredData'.tr);
      }

      FocusScope.of(context).unfocus();

      setState(() {
        translatedAddress = '';
        isTranslating = true;
      });

      final response = await openAIProvider.executeQuery(_addressController.text);
      systemProvider.decrementPoint(ADDRESS_TRANSLATE_DECREMENT_POINT);

      setState(() {
        isTranslating = false;
        translatedAddress = response;
      });
    } catch (e) {
      Get.defaultDialog(
        title: 'error'.tr,
        titleStyle: const TextStyle(
          fontSize: 20,
        ),
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
          Padding(
            padding: const EdgeInsets.only(left: SPACE_SIZE_12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.payments_outlined,
                  size: ICON_SIZE_40,
                  color: Get.isDarkMode ? Colors.white70 : Colors.black87,
                ),
                const SizedBox(width: SPACE_SIZE_12),
                Obx(() => Text(
                      '${convertLocaleNumberFormat(systemProvider.point.value)}P',
                      style: Theme.of(context).textTheme.headlineLarge,
                    )),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(SPACE_SIZE_8),
                    child: TextField(
                      readOnly: isTranslating,
                      style: const TextStyle(
                        backgroundColor: Colors.transparent,
                      ),
                      controller: _addressController,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: 5,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                        labelText: 'addressTextFieldHinttext'.tr,
                      ),
                    ),
                  ),
                  if (translatedAddress.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 12, left: 12, bottom: 12),
                      child: renderResultArea(),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: isTranslating
                        ? LinearProgressIndicator(
                            minHeight: 20,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Get.isDarkMode ? Colors.white60 : Colors.black54,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : ActionButtonWidget(
                            onPressed: () => handleTryTranslate(context),
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

  Widget renderResultArea() {
    if (translatedAddress.contains("reject")) {
      return Text(
        'translateError'.tr,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }

    return ListTile(
      tileColor: Get.isDarkMode ? Colors.black87 : Colors.white,
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

              Get.snackbar('copiedText'.tr, translatedAddress);
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }
}
