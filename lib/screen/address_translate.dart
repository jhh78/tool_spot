import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class AddressTranslate extends StatefulWidget {
  const AddressTranslate({super.key});

  @override
  State<AddressTranslate> createState() => _AddressTranslateState();
}

class _AddressTranslateState extends State<AddressTranslate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddressTranslate'.tr),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '999pt',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () {
                      log('menu');
                    },
                    icon: const Icon(Icons.list_alt),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: 5,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    labelText: 'Address'.tr,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Text('Banner Ad Placeholder'),
            ),
          ),
        ],
      ),
    );
  }
}
