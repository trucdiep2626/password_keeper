import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:password_keeper/common/config/app_config.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/presentation/widgets/export.dart';
import 'package:permission_handler/permission_handler.dart';

void logger(String message) {
  log('app_logger: {$message}');
}

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String formatCurrency(dynamic number) {
  if (isNullEmptyFalseOrZero(number) || !isNumeric(number)) {
    return '0';
  }
  dynamic numberConvert;
  if (number is String) {
    numberConvert = int.tryParse(number) ?? double.tryParse(number);
  } else {
    numberConvert = number;
  }
  return NumberFormat("#,###", AppConfig.defaultLocate)
      .format(numberConvert ?? 0);
}

String formatPhoneNumber(String phoneNumber) {
  var filterText = phoneNumber;
  if (isNullEmpty(filterText)) return '';
  filterText = filterText.replaceAll(' ', '');
  if (filterText.length < 2) return filterText;
  final firstChars = filterText.substring(0, 2);
  if (firstChars == '09' ||
      firstChars == '08' ||
      firstChars == '07' ||
      firstChars == '03' ||
      firstChars == '05') {
    if (filterText.length > 3) {
      filterText = '${filterText.substring(0, 3)} ${filterText.substring(3)}';
    }
    if (filterText.length > 7) {
      filterText = '${filterText.substring(0, 7)} ${filterText.substring(7)}';
    }
  }
  return filterText.trim();
}

bool isNullEmpty(Object? o) => o == null || "" == o || o == "null";

bool isNullEmptyOrFalse(Object? o) => o == null || false == o || "" == o;

bool isNullEmptyFalseOrZero(Object? o) =>
    o == null || false == o || 0 == o || "" == o || "0" == o;

bool isNullEmptyList<T>(List<T>? t) => t == null || [] == t || t.isEmpty;

bool isNullEmptyMap<T>(Map<T, T>? t) => t == null || {} == t || t.isEmpty;

bool isNumeric(dynamic s) {
  String sConvert = s.toString();
  if (isNullEmpty(sConvert)) {
    return false;
  }
  return (double.tryParse(sConvert) != null || int.tryParse(sConvert) != null);
}

bool isNullOrWhiteSpace(String? o) =>
    o == null || "" == o.trim() || o.trim() == "null";

Future<bool> checkPermission(Permission permission) async {
  final status = await permission.request();
  return status.isGranted;
}

void handleFirebaseException({
  required String code,
  bool isSignIn = false,
}) {
  String message = '';
  switch (code) {
    case 'email-already-in-use':
      message = TranslationConstants.existingEmail.tr;
      break;
    case 'invalid-email':
      message = isSignIn
          ? TranslationConstants.loginError.tr
          : TranslationConstants.invalidEmail.tr;
      break;
    case 'operation-not-allowed':
      message = TranslationConstants.unknownError.tr;
      break;
    case 'weak-password':
      message = TranslationConstants.weakPasswordError.tr;
      break;

    default:
      if (isSignIn) {
        message = TranslationConstants.loginError.tr;
      } else {
        message = TranslationConstants.unknownError.tr;
      }
  }

  if (Get.context != null) {
    showTopSnackBarError(Get.context!, message);
  }
}

const String _dateYearFormat = 'dd/MM/yyyy - HH:mm';

String millisecondToDateTimeString({required int millisecond}) {
  return DateFormat(_dateYearFormat)
      .format(DateTime.fromMillisecondsSinceEpoch(millisecond));
}

Future<void> copyText({required String text}) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
    // copied successfully
    showTopSnackBar(
      Get.context!,
      message: TranslationConstants.copiedSuccessfully.tr,
    );
  } catch (e) {
    // copied fail
    showTopSnackBar(
      Get.context!,
      message: TranslationConstants.unknownError.tr,
      type: SnackBarType.error,
    );
  }
}

void showErrorMessage() {
  if (Get.context != null) {
    showTopSnackBarError(Get.context!, TranslationConstants.unknownError.tr);
  }
}

Future<bool> checkConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    if (Get.context != null) {
      showTopSnackBarError(
          Get.context!, TranslationConstants.noConnectionError.tr);
    }

    return false;
  }
  return true;
}

String dateTimeNowToString() {
  const offset = 7;
  DateTime now = DateTime.now().toUtc().add(const Duration(hours: offset));
  String formattedDate = DateFormat('hh:mm:ss dd-MM-yyyy').format(now);
  return '$formattedDate (UTC+$offset)';
}

int daysToMilliseconds(int days) => days * 24 * 60 * 60 * 1000;

int millisecondsToDays (int milliseconds) => (milliseconds/(24 * 60 * 60 * 1000)).ceil();
