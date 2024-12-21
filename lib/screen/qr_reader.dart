import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:life_secretary/widget/button/flash.dart';
import 'package:life_secretary/widget/button/zoom.dart';
import 'package:life_secretary/widget/clip/rectangle.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrReaderScreen extends StatefulWidget {
  const QrReaderScreen({super.key});

  @override
  State<QrReaderScreen> createState() => _QrReaderScreenState();
}

class _QrReaderScreenState extends State<QrReaderScreen> {
  MobileScannerController controller = MobileScannerController();
  bool isDetecting = false;
  bool isWebAddress = false;
  final double scanAreaWidth = 250;
  final double scanAreaHeight = 250;

  @override
  void initState() {
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

  void _handleBarcode(BarcodeCapture barcodes) {
    if (isDetecting) {
      return;
    }

    if (mounted) {
      setState(() {
        isDetecting = true;
      });

      final code = barcodes.barcodes.firstOrNull?.rawValue.toString();
      final isWebAssress = code?.contains('http') ?? false;
      final qrModalDescription = isWebAssress ? 'qrModalDescription'.tr : 'qrModalDescriptionFail'.tr;

      Get.dialog(
        AlertDialog(
          title: isWebAssress
              ? Text(
                  'qrModalTitle'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              : null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                qrModalDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
              ),
              if (isWebAssress) Text('${barcodes.barcodes.firstOrNull?.rawValue}'),
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
            if (isWebAssress)
              TextButton(
                onPressed: () {
                  setState(() {
                    isDetecting = false;
                  });

                  launchUrl(Uri.parse(code.toString()));
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
      appBar: AppBar(
        title: Text('qrReaderTitle'.tr),
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
                      painter: RectangleBorderPainter(),
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
