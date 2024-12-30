import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/screen/webview.dart';
import 'package:life_secretary/widget/button/flash.dart';
import 'package:life_secretary/widget/button/zoom.dart';
import 'package:life_secretary/widget/clip/rectangle.dart';
import 'package:life_secretary/widget/paint/qr_code_reader_border.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrReaderScreen extends StatefulWidget {
  const QrReaderScreen({super.key});

  @override
  State<QrReaderScreen> createState() => _QrReaderScreenState();
}

class _QrReaderScreenState extends State<QrReaderScreen> {
  MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  final RouterProvider routerProvider = Get.put(RouterProvider());
  bool isDetecting = false;
  bool isWebAddress = false;
  final double scanAreaWidth = 250;
  final double scanAreaHeight = 250;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (isDetecting) {
      return;
    }

    if (mounted) {
      setState(() {
        isDetecting = true;
      });

      final code = barcodes.barcodes.firstOrNull?.rawValue.toString() ?? "";

      Get.dialog(
        AlertDialog(
          title: Text(
            'qrModalTitle'.tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'qrModalDescription'.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
              Text('${barcodes.barcodes.firstOrNull?.rawValue}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isDetecting = false;
                });
                Get.back();
              },
              child: Text('close'.tr),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isDetecting = false;
                });

                Future.delayed(const Duration(milliseconds: 500), () {
                  Get.to(() => WebViewScreen(url: code));
                });
                Get.back();
              },
              child: Text('accessSite'.tr),
            ),
          ],
        ),
      ).then((_) {
        setState(() {
          isDetecting = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      painter: QrCodeReaderBorder(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlashButtonWidget(controller: controller),
                        ZoomButtonWidget(controller: controller),
                      ],
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
