import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddressTranslateHistoryWidget extends StatefulWidget {
  const AddressTranslateHistoryWidget({super.key});

  @override
  State<AddressTranslateHistoryWidget> createState() => _AddressTranslateHistoryWidgetState();
}

class _AddressTranslateHistoryWidgetState extends State<AddressTranslateHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      log('Remove $index');
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  IconButton(
                    onPressed: () {
                      log('Copy $index');
                      Clipboard.setData(
                        ClipboardData(text: 'Translated Address $index'),
                      );

                      Get.snackbar(
                        'Copied',
                        'Translated Address $index',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
              title: Text('Address $index'),
              subtitle: Text('Translated Address $index'),
            ),
          );
        },
      ),
    );
  }
}
