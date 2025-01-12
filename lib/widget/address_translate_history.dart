import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_secretary/model/address_converter.dart';

class AddressTranslateHistoryWidget extends StatefulWidget {
  const AddressTranslateHistoryWidget({super.key, required this.list, required this.onDelete});
  final List<AddressConverterModel> list;
  final void Function(int id) onDelete;

  @override
  State<AddressTranslateHistoryWidget> createState() => _AddressTranslateHistoryWidgetState();
}

class _AddressTranslateHistoryWidgetState extends State<AddressTranslateHistoryWidget> {
  Widget renderListView() {
    if (widget.list.isEmpty) {
      return Center(
        child: Text('dataNotFound'.tr),
      );
    }

    return ListView.builder(
      itemCount: widget.list.length,
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => widget.onDelete(widget.list[index].id!),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.list[index].address),
                    );

                    Get.snackbar('copiedText'.tr, widget.list[index].address);
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
            title: Text(widget.list[index].address),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: renderListView(),
    );
  }
}
