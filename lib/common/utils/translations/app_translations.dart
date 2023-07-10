import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'en_string.dart';
import 'vi_string.dart';

const Iterable<Locale> appSupportedLocales = [Locale('vi', 'VN'), Locale('en', 'US')];

class AppTranslations extends Translations {
  static const String localeCodeVi = 'vi_VN';
  static const String localeCodeEn = 'en_US';

  @override
  Map<String, Map<String, String>> get keys => {
    localeCodeVi: viString,
    localeCodeEn: enString,
  };

  static String unknownError = 'unknownError';
  static String noConnectionError = 'noConnectionError';
}

class TransactionConstants {
  static const unknownError = 'unknownError';
  static const noConnectionError = 'noConnectionError';
  static const mainNavigationHome = 'main.navigation.home';
  static const mainNavigationFinance = 'main.navigation.finance';
  static const mainNavigationWorkflow = 'main.navigation.workflow';
  static const mainNavigationAccount = 'main.navigation.account';


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
static const String finance = 'finance';
static const String workflow = 'workflow';
static const String love = 'love';
static const String account = 'account';
static const String hi = 'hi';
static const String quickAdd = 'quickAdd';
static const String transaction = 'transaction';
static const String addTransaction = 'addTransaction';
static const String addWorkflow = 'addWorkflow';
static const String requiredInfo = 'requiredInfo';
static const String otherInfo = 'otherInfo';
static const String transactionAmount = 'transactionAmount';
static const String transactionType = 'transactionType';
static const String transactionDate = 'transactionDate';
static const String description = 'description';
static const String selectTransactionType = 'selectTransactionType';
static const String selectTransactionDate = 'selectTransactionDate';
static const String expense = 'expense';
static const String revenue = 'revenue';
static const String debtAndLoan = 'debtAndLoan';
static const String eating = 'eating';
static const String coffee = 'coffee';
static const String drinking = 'drinking';
static const String restaurant = 'restaurant';
static const String friendAndLover = 'friendAndLover';
static const String shopping = 'shopping';
static const String donate = 'donate';
static const String move = 'move';
static const String billAndUtilities = 'billAndUtilities';
static const String maintenance = 'maintenance';
static const String parking = 'parking';
static const String taxi = 'taxi';
static const String gasStation = 'gasStation';
static const String investment = 'investment';
static const String traveling = 'traveling';
static const String family = 'family';
static const String education = 'education';
static const String business = 'business';
static const String health = 'health';
static const String other = 'other';
static const String chooseImage = 'chooseImage';
static const String chooseWallet = 'chooseWallet';
static const String myWallet = 'myWallet';
static const String financialManagement = 'financialManagement';
static const String category = 'category';
static const String emptyData = 'emptyData';
static const String amount = 'amount';
static const String save = 'save';
}