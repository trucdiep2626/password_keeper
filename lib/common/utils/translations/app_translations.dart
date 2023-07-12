import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'en_string.dart';
import 'vi_string.dart';

const Iterable<Locale> appSupportedLocales = [
  Locale('vi', 'VN'),
  Locale('en', 'US')
];

class AppTranslations extends Translations {
  static const String localeCodeVi = 'vi_VN';
  static const String localeCodeEn = 'en_US';

  @override
  Map<String, Map<String, String>> get keys => {
        localeCodeVi: viString,
        localeCodeEn: enString,
      };
}

class TransactionConstants {

  //messages
  static const String verifyPhoneContent = 'verifyPhoneContent';
  static const String verificationFailed = 'verificationFailed';
  static const String requestTimeOut = 'requestTimeOut';
  static const String didNotReceiveTheCode = 'didNotReceiveTheCode';

  static const String login = 'login';
  static const String verifyPhone = 'verifyPhone';
  static const String phone = 'phone';
  static const String invalidPhone = 'invalidPhone';

  static const String resend = 'resend';
  static const String confirm = 'confirm';
  static const String home = 'home';

  static const String account = 'account';
  static const String requiredInfo = 'requiredInfo';
  static const String otherInfo = 'otherInfo';

  static const String description = 'description';

  static const String other = 'other';
  static const String emptyData = 'emptyData';
  static const String save = 'save';

  static const String unknownError = 'unknown_error';
  static const String noConnectionError ='no_connection_error';



  static const String contactInformation = "contact_information";
  static const String logout =  "logout";
  static const String accountInformation = "account_information";
  static const String editAccountInformation = "edit_account_information";

  //login
  static const String signIn ="sign_in";
  static const String forgetPassword = "forget_assword";
  static const String loginError = "login_rror";

  //  signup
  static const String signup = "signup";
  static const String createAccount ="create_account";
  static const String fullname = "fullname";
  static const String email ="email";
  static const String password = "password";
  static const String confirmPassword = "confirm_password";
  static const String dontHaveAnAccount = "dont_have_an_account";
  static const String alreadyHaveAnAccount = "already_have_an_account";
}
