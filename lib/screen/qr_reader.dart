import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/widget/button/flash.dart';
import 'package:life_secretary/widget/button/zoom.dart';
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

      Get.dialog(
        AlertDialog(
          title: Text(
            'qrModalTitle'.tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('qrModalDescription'.tr, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red)),
              Text('Url: ${barcodes.barcodes.firstOrNull?.rawValue}'),
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

                launchUrl(Uri.parse(barcodes.barcodes.firstOrNull!.rawValue.toString()));
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
      body: Stack(
        children: [
          Stack(
            children: [
              MobileScanner(
                controller: controller,
                onDetect: _handleBarcode,
              ),
            ],
          )
        ],
      ),
    );
  }
}
