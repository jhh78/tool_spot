import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_secretary/screen/webview.dart';
import 'package:life_secretary/widget/button/flash.dart';
import 'package:life_secretary/widget/button/zoom.dart';
import 'package:life_secretary/widget/clip/rectangle.dart';
import 'package:life_secretary/widget/paint/bar_code_reader_border.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeReaderScreen extends StatefulWidget {
  const BarcodeReaderScreen({super.key});

  @override
  State<BarcodeReaderScreen> createState() => _BarcodeReaderScreenState();
}

class _BarcodeReaderScreenState extends State<BarcodeReaderScreen> {
  MobileScannerController controller = MobileScannerController(
    formats: [
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
  );
  final double scanAreaWidth = 300;
  final double scanAreaHeight = 200;

  @override
  void initState() {
    log('BarcodeReaderScreen initState');
    super.initState();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      final barcode = barcodes.barcodes.firstOrNull?.rawValue.toString() ?? "";
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => WebViewScreen(url: 'https://www.google.com/search?q=$barcode'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('barcodeReaderTitle'.tr),
        actions: [
          FlashButtonWidget(controller: controller),
          ZoomButtonWidget(controller: controller),
        ],
      ),
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Stack(
                children: [
                  MobileScanner(
                    controller: controller,
                    onDetect: _handleBarcode,
                    scanWindow: Rect.fromCenter(
                      center: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
                      width: scanAreaWidth,
                      height: scanAreaHeight,
                    ),
                  ),
                  Positioned.fill(
                    child: ClipPath(
                      clipper: RectangleClipper(
                        top: (constraints.maxWidth - scanAreaWidth) / 2,
                        left: (constraints.maxHeight - scanAreaHeight) / 2,
                        width: scanAreaWidth,
                        height: scanAreaHeight,
                      ),
                      child: Container(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomPaint(
                      size: Size(scanAreaWidth, scanAreaHeight),
                      painter: BarCodeReaderBorder(),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
