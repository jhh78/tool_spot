import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ZoomButtonWidget extends StatefulWidget {
  const ZoomButtonWidget({super.key, required this.controller});
  final MobileScannerController controller;

  @override
  State<ZoomButtonWidget> createState() => _ZoomButtonWidgetState();
}

class _ZoomButtonWidgetState extends State<ZoomButtonWidget> {
  bool isZoom = false;
  final double zoomIn = 0.45;
  final double zoomOut = 0.8;
  final Color iconColor = Get.isDarkMode ? Colors.white : Colors.black;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isZoom = !isZoom;
          widget.controller.setZoomScale(isZoom ? zoomOut : zoomIn);
        });
      },
      icon: isZoom
          ? Icon(
              Icons.zoom_out_map_outlined,
              size: Theme.of(context).textTheme.headlineLarge?.fontSize,
              color: iconColor,
            )
          : Icon(
              Icons.zoom_in_map_outlined,
              size: Theme.of(context).textTheme.headlineLarge?.fontSize,
              color: iconColor,
            ),
    );
  }
}
