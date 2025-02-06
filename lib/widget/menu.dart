import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_secretary/provider/router.dart';
import 'package:life_secretary/provider/system.dart';
import 'package:life_secretary/util/util.dart';
import 'package:life_secretary/widget/menu_card.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({
    super.key,
  });

  final SystemProvider systemProvider = Get.put(SystemProvider());
  final RouterProvider routerProvider = Get.put(RouterProvider());

  List<MenuCard> onlyJPMenu(BuildContext context) {
    if (Get.locale?.languageCode != 'ja') {
      return [];
    }

    return [
      MenuCard(
        descript: 'zipcodeSearchTitle'.tr,
        emoji: '〒',
        callback: () => routerProvider.changeScreen(context, ROUTER_ZIPCODE_SEARCH),
      ),
    ];
  }

  List<MenuCard> onlyKRMenu(BuildContext context) {
    if (Get.locale?.languageCode != 'ko') {
      return [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuCard> menuCards = [
      MenuCard(
        descript: 'qrReaderTitle'.tr,
        icon: Icons.qr_code_rounded,
        callback: () => routerProvider.changeScreen(context, ROUTER_QRREADER),
      ),
      MenuCard(
        descript: 'pdfConverterTitle'.tr,
        icon: Icons.picture_as_pdf_outlined,
        callback: () => routerProvider.changeScreen(context, ROUTER_PICTURE_TO_PDF),
      ),
      MenuCard(
        descript: 'addressTranslate'.tr,
        icon: Icons.translate,
        callback: () => routerProvider.changeScreen(context, ROUTER_ADDRESSTRANSLATE),
      ),
      MenuCard(
        descript: 'holidayCalender'.tr,
        icon: Icons.calendar_month_outlined,
        callback: () => routerProvider.changeScreen(context, ROUTER_HOLIDAY_CALENDER),
      ),
      ...onlyJPMenu(context),
      ...onlyKRMenu(context),
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: getGridCardSize(context),
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: menuCards.length,
        itemBuilder: (BuildContext context, int index) {
          return menuCards[index];
        },
      ),
    );
  }
}
