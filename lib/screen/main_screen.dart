import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/system.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SystemProvider systemProvider = Get.find<SystemProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mainHomeTitle'.tr),
      ),
      body: const Center(
        child: Text('Main Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          systemProvider.toggleTheme();
        },
        child: const Icon(Icons.brightness_4),
      ),
    );
  }
}
