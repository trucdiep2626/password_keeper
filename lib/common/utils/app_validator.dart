import 'package:flutter/material.dart';

enum AppValidation {
  name,
  phoneNo,
  address,
  email,
  username,
  password,
  dateTime,
  amount,
  imageUpload,
  fileUpload,
  bankAccNo,
  creditCardNo,
  visaCardNo,
}

final _pattern = <AppValidation, Pattern>{
  AppValidation.name:
  r'^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêếìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹý ]{3,255}$',
  AppValidation.phoneNo:
  r'(086|096|097|098|032|033|034|035|036|037|038|039|091|094|088|083|084|085|081|082|089|090|093|070|079|077|076|078|092|056|058|099|059)+([0-9]{7,12})\b',
  AppValidation.address: r'^((\\d,)?\\d,\\d,\\d,){3,255}$',
  AppValidation.email: r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  AppValidation.username: r'^([a-zA-Z0-9\.\-]{6,50})$',
  AppValidation.password: r'^[a-zA-Z0-9!@#\\$%\\^\\&*\\)\\(+=._-]{6,20}$',
  AppValidation.dateTime:
  r'^(([0-9]{4}\-[0-9]{2}\-[0-9]{2}T[0-9]{2}\:[0-9]{2}\:[0-9]{2}Z))|(([0-9]{4}\-[0-9]{2}\-[0-9]{2}T[0-9]{2}\:[0-9]{2}\:[0-9]{2}\+[0-9]{2}\:[0-9]{2}))$',
  AppValidation.amount: r'^(?:\\d{1,3}(?:,\\d{3})*|\\d+)(?:.\\d+)?$',
  AppValidation.imageUpload: r'',
  AppValidation.fileUpload: r'',
  AppValidation.bankAccNo: r'^[0-9A-Za-z?]{5,16}$',
  AppValidation.creditCardNo: r'^(9704|6201) \d{4} \d{4} ?\d{0,4}$',
  AppValidation.visaCardNo: r'^4[0-9]{12}(?:[0-9]{3})?$',
};

class AppValidator {
  static String error(String? value, AppValidation type, String illegal) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    RegExp regExp = RegExp(_pattern[type] as String);
    if (regExp.hasMatch(value.replaceAll(RegExp(r"\s+"), ""))) {
      return '';
    }
    return illegal;
  }

  static String validateEmail(TextEditingController emailCtrl) {
    return error(
      emailCtrl.text,
      AppValidation.email,
      'Email không đúng định dạng',
    );
  }
  //
  // static String validatePhoneNumber(TextEditingController phoneCtrl) {
  //   String phone = phoneCtrl.text.replaceAll(' ', '');
  //   return error(
  //     phone,
  //     AppValidation.phoneNo,
  //     AppTranslations.invalidPhone.tr,
  //   );
  // }

  static String validatePassword(TextEditingController passwordCtrl) {
    return error(
      passwordCtrl.text.trim(),
      AppValidation.password,
      'Mật khẩu phải từ 6-20 ký tự',
    );
  }

  static String validateName(TextEditingController nameCtrl) {
    return error(
      nameCtrl.text,
      AppValidation.name,
      'Nhập Họ và tên từ 3-255 ký tự',
    );
  }

  static String validateAccNumber(TextEditingController accNumberCtrl) {
    return error(
      accNumberCtrl.text.trim(),
      AppValidation.bankAccNo,
      'Số tài khoản không đúng định dạng',
    );
  }
}