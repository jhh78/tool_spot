import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/validate.dart';
import 'package:life_secretary/util/constants.dart';

class DropdownMenuWidget extends StatefulWidget {
  const DropdownMenuWidget({
    super.key,
    required this.list,
    this.onChanged,
    this.initialSelection,
    this.helperText,
    this.errorText,
  });

  final List<dynamic> list;
  final Function(int? value)? onChanged;

  final int? initialSelection;
  final String? helperText;
  final String? errorText;

  @override
  State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  final ValidateProvider validateProvider = Get.put(ValidateProvider());

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        errorStyle: const TextStyle(fontSize: 0),
      ),
      menuHeight: DROPDOWN_MENU_ITEM_HEIGHT,
      width: 100,
      initialSelection: widget.initialSelection,
      hintText: widget.helperText,
      textAlign: TextAlign.center,
      errorText: !validateProvider.error.value ? null : "",
      dropdownMenuEntries: List.generate(widget.list.length, (index) {
        return DropdownMenuEntry(
          label: widget.list[index].toString(),
          value: index,
        );
      }),
      onSelected: widget.onChanged,
    );
  }
}
