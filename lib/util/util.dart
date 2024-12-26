import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:life_secretary/util/constants.dart';

// 아이콘 크기를 반환하는 함수
double getIconSize(BuildContext context) {
  if (checkDeviceType(context) == DeviceTypes.w600) {
    return MediaQuery.of(context).size.width / 7;
  } else if (checkDeviceType(context) == DeviceTypes.w800) {
    return MediaQuery.of(context).size.width / 9;
  } else if (checkDeviceType(context) == DeviceTypes.w1000) {
    return MediaQuery.of(context).size.width / 10;
  } else if (checkDeviceType(context) == DeviceTypes.w1200) {
    return MediaQuery.of(context).size.width / 12;
  }

  return MediaQuery.of(context).size.width / 5;
}

// 텍스트 크기를 반환하는 함수
double getTextSize(BuildContext context) {
  if (checkDeviceType(context) == DeviceTypes.w600) {
    return MediaQuery.of(context).size.width / 40;
  } else if (checkDeviceType(context) == DeviceTypes.w800) {
    return MediaQuery.of(context).size.width / 40;
  } else if (checkDeviceType(context) == DeviceTypes.w1000) {
    return MediaQuery.of(context).size.width / 60;
  } else if (checkDeviceType(context) == DeviceTypes.w1200) {
    return MediaQuery.of(context).size.width / 80;
  }

  return MediaQuery.of(context).size.width / 30;
}

// 그리드 카드 크기를 반환하는 함수
double getGridCardSize(BuildContext context) {
  log('getGridCardSize: ${checkDeviceType(context)}');
  if (checkDeviceType(context) == DeviceTypes.w600) {
    return MediaQuery.of(context).size.width / 4;
  } else if (checkDeviceType(context) == DeviceTypes.w800) {
    return MediaQuery.of(context).size.width / 5;
  } else if (checkDeviceType(context) == DeviceTypes.w1000) {
    return MediaQuery.of(context).size.width / 6;
  } else if (checkDeviceType(context) == DeviceTypes.w1200) {
    return MediaQuery.of(context).size.width / 7;
  }

  return MediaQuery.of(context).size.width / 3;
}

// 디바이스사이즈를 확인하는 함수
DeviceTypes checkDeviceType(BuildContext context) {
  log('checkDeviceTyps: ${MediaQuery.of(context).size.width}');

  if (MediaQuery.of(context).size.width < 600) {
    return DeviceTypes.w400;
  } else if (MediaQuery.of(context).size.width < 800) {
    return DeviceTypes.w600;
  } else if (MediaQuery.of(context).size.width < 1000) {
    return DeviceTypes.w800;
  } else if (MediaQuery.of(context).size.width < 1200) {
    return DeviceTypes.w1000;
  } else if (MediaQuery.of(context).size.width < 1400) {
    return DeviceTypes.w1200;
  }

  return DeviceTypes.w400;
}
