import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ActionButtonWidget extends StatelessWidget {
  const ActionButtonWidget({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.middleText,
  });

  final VoidCallback onPressed;
  final String buttonText;
  final String? middleText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (middleText != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              middleText!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
