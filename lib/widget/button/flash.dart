import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FlashButtonWidget extends StatefulWidget {
  const FlashButtonWidget({super.key, required this.controller});
  final MobileScannerController controller;

  @override
  State<FlashButtonWidget> createState() => _FlashButtonWidgetState();
}

class _FlashButtonWidgetState extends State<FlashButtonWidget> {
  bool isTorchOn = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isTorchOn = !isTorchOn;
          widget.controller.toggleTorch();
        });
      },
      icon: isTorchOn
          ? Icon(
              Icons.flash_on,
              size: Theme.of(context).textTheme.headlineLarge?.fontSize,
              color: Colors.white,
            )
          : Icon(
              Icons.flash_off,
              size: Theme.of(context).textTheme.headlineLarge?.fontSize,
              color: Colors.white,
            ),
    );
  }
}
