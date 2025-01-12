import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_secretary/util/constants.dart';

// 아이콘 크기를 반환하는 함수
double getIconSize(BuildContext context) {
  final int width = MediaQuery.of(context).size.width.toInt();

  if (checkDeviceType(context) == DEVICE_TYPES.w600) {
    return width / 7;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w800) {
    return width / 9;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w1000) {
    return width / 10;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w1200) {
    return width / 12;
  }

  return width / 5;
}

// 텍스트 크기를 반환하는 함수
double getTextSize(BuildContext context) {
  final int width = MediaQuery.of(context).size.width.toInt();

  if (checkDeviceType(context) == DEVICE_TYPES.w600) {
    return width / 40;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w800) {
    return width / 40;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w1000) {
    return width / 60;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w1200) {
    return width / 80;
  }

  return width / 30;
}

// 그리드 카드 크기를 반환하는 함수
double getGridCardSize(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;

  if (checkDeviceType(context) == DEVICE_TYPES.w600) {
    return width / 4;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w800) {
    return width / 5;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w1000) {
    return width / 6;
  } else if (checkDeviceType(context) == DEVICE_TYPES.w1200) {
    return width / 7;
  }

  return width / 3;
}

// 디바이스사이즈를 확인하는 함수
DEVICE_TYPES checkDeviceType(BuildContext context) {
  final int width = MediaQuery.of(context).size.width.toInt();
  log('check device width : $width');

  if (width < 600) {
    return DEVICE_TYPES.w400;
  } else if (width < 800) {
    return DEVICE_TYPES.w600;
  } else if (width < 1000) {
    return DEVICE_TYPES.w800;
  } else if (width < 1200) {
    return DEVICE_TYPES.w1000;
  } else if (width < 1400) {
    return DEVICE_TYPES.w1200;
  }

  return DEVICE_TYPES.w400;
}

// 로케일 숫자 포맷을 변환하는 함수
String convertLocaleNumberFormat(int value) => NumberFormat('#,###').format(value);

// 로케일 날짜 포맷을 변환하는 함수
String convertLocaleDateFormat(DateTime date) => DateFormat(DATE_FORMAT).format(date);

// 로케일 시간 포맷을 변환하는 함수
String convertLocaleTimeFormat(DateTime date) => DateFormat(TIME_FORMAT).format(date);

// 로케일 날짜시간 포맷을 변환하는 함수
String convertLocaleDateTimeFormat(DateTime date) => DateFormat(DATE_TIME_FORMAT).format(date);
