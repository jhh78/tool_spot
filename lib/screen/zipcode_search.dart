import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:life_secretary/model/search_zipcode.dart';
import 'package:life_secretary/util/styles.dart';
import 'package:http/http.dart' as http;

class ZipcodeSearchScreen extends StatefulWidget {
  const ZipcodeSearchScreen({super.key});

  @override
  State<ZipcodeSearchScreen> createState() => _ZipcodeSearchScreenState();
}

class _ZipcodeSearchScreenState extends State<ZipcodeSearchScreen> {
  final List<ZipResult> _zipCode = [];
  final TextEditingController _zipCodeController = TextEditingController();
  final String jpBaseUrl = dotenv.env['JP_ZIPCODE_SEARCH_API']!;
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

    final response = await http.get(Uri.parse('$jpBaseUrl?zipcode=${_zipCodeController.text}'));
    final searchZipcode = SearchZipcode.fromJson(jsonDecode(response.body));

    if (searchZipcode.status != 200 || searchZipcode.message != null) {
      Get.snackbar('error'.tr, searchZipcode.message!, backgroundColor: Colors.red.shade400, colorText: Colors.white);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    log('error: ${searchZipcode.toString()}');
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _zipCode.clear();
      _zipCode.addAll(searchZipcode.results!);
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
        final String address = "${_zipCode[index].address1}${_zipCode[index].address2}${_zipCode[index].address3}";
        return ListTile(
          trailing: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: address));
                Get.snackbar('copiedText'.tr, address);
              },
              icon: const Icon(
                Icons.copy,
                size: SPACE_SIZE_32,
              )),
          title: Text(address),
        );
      },
    );
  }
}
