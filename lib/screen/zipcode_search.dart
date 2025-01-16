import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_secretary/util/styles.dart';

class ZipcodeSearchScreen extends StatefulWidget {
  const ZipcodeSearchScreen({super.key});

  @override
  State<ZipcodeSearchScreen> createState() => _ZipcodeSearchScreenState();
}

class _ZipcodeSearchScreenState extends State<ZipcodeSearchScreen> {
  final List<String> _zipCode = [];
  final TextEditingController _zipCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isError = false;

  Future<void> fetchZipcodeResults() async {
    if (_zipCodeController.text.isEmpty) {
      setState(() {
        _isError = true;
      });
      return;
    }

    setState(() {
      _isError = false;
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _zipCode.clear();
      _zipCode.addAll(['12345', '67890', '23456', '78901', '23456', '23456', '23456', '23456', '23456', '23456', '23456']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _zipCodeController,
                  decoration: InputDecoration(
                    labelText: 'zipcodeSearchHelperText'.tr,
                    helperText: 'zipcodeSearchHintText'.tr,
                    error: _isError ? Text('error'.tr) : null,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                  onPressed: fetchZipcodeResults,
                  icon: const Icon(
                    Icons.search,
                  )),
            ],
          ),
          const SizedBox(height: SPACE_SIZE_16),
          Expanded(
            child: renderItem(),
          ),
        ],
      ),
    ));
  }

  Widget renderItem() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_zipCode.isEmpty) {
      return Center(child: Text('dataNotFound'.tr));
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: _zipCode.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          trailing: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _zipCode[index]));
                Get.snackbar('copiedText'.tr, _zipCode[index]);
              },
              icon: const Icon(
                Icons.copy,
                size: SPACE_SIZE_32,
              )),
          title: Text(_zipCode[index]),
        );
      },
    );
  }
}
