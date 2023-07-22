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
  // static const String verifyPhoneContent = 'verifyPhoneContent';
  // static const String verificationFailed = 'verificationFailed';
  // static const String requestTimeOut = 'requestTimeOut';
  // static const String didNotReceiveTheCode = 'didNotReceiveTheCode';
  //
  // static const String verifyPhone = 'verifyPhone';
  // static const String phone = 'phone';
  // static const String invalidPhone = 'invalidPhone';

  //common
  static const String resend = 'resend';
  static const String confirm = 'confirm';
  static const String description = 'description';
  static const String other = 'other';
  static const String save = 'save';
  static const String ok = "ok";
  static const String cancel = "cancel";
  static const String delete = "delete";
  static const String welcomBack ="welcome_back";
  static const String unlock ="unlock";


  //main
  static const String home = 'home';
  static const String account = 'account';

  //account
  static const String contactInformation = "contact_information";
  static const String logout = "logout";
  static const String accountInformation = "account_information";
  static const String editAccountInformation = "edit_account_information";

  //login
  static const String signIn = "sign_in";
  static const String forgetPassword = "forget_password";
  static const String loginError = "login_error";
  static const String dontHaveAnAccount = "dont_have_an_account";
  static const String orSignInWith ="or_signin_with";

  //  signup
  static const String signUp = "sign_up";
  static const String createAccount = "create_account";
  static const String fullname = "fullname";
  static const String email = "email";
  static const String password = "password";
  static const String confirmPassword = "confirm_password";
  static const String alreadyHaveAnAccount = "already_have_an_account";
  static const String setupNewAccount = "setup_new_account";
  static const String emailAlreadyInUse ="email_already_in_use";

  static const String confirmPasswordError = "confirm_password_error";

  //master password
  static const String createMasterPassword = "create_master_password";
  static const String masterPasswordDescription = "master_password_description";
  static const String masterPassword = "master_password";
  static const String confirmMasterPassword = "confirm_master_password";
  static const String masterPasswordNote = "master_password_note";
  static const String masterPasswordHint = "master_password_hint";
  static const String masterPasswordHintNote = "master_password_hint_note";
  static const String masterPasswordError = "master_password_error";
  static const String getMasterPasswordHint = "get_master_password_hint";
  static const String notYou = "not_you";
  static const String enterMasterPassword ="enter_master_password";
  static const String unlockBiometric ="unlock_biometric";


  //error message
  static const String error = "error";
  static const String invalidEmail = "invalid_email";
  static const String unknownError = 'unknown_error';
  static const String noConnectionError = 'no_connection_error';
  static const String requiredFields = "required_fields";
  static const String noData ="no_data";
  static const String offline ="offline";
  static const String internetRestore ="internet_restore";
}
