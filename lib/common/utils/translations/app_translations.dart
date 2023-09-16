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

class TranslationConstants {
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
  static const String welcomeBack = "welcome_back";
  static const String unlock = "unlock";
  static const String continueButton = "continue";
  static const String search = "search";
  static const String continueAnyway = "continue_anyway";
  static const String tryAgain = "try_again";
  static const String edit = "edit";

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
  static const String orSignInWith = "or_signin_with";

  //  signup
  static const String signUp = "sign_up";
  static const String createAccount = "create_account";
  static const String fullname = "fullname";
  static const String email = "email";
  static const String password = "password";
  static const String confirmPassword = "confirm_password";
  static const String alreadyHaveAnAccount = "already_have_an_account";
  static const String setupNewAccount = "setup_new_account";
  static const String emailAlreadyInUse = "email_already_in_use";
  static const String verificationSent = "verification_sent";
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
  static const String enterMasterPassword = "enter_master_password";
  static const String unlockBiometric = "unlock_biometric";
  static const String wrongMasterPassword = "wrong_master_password";

  //verify email
  static const String verifyEmail = "verify_email";
  static const String verifyEmailDescription = "verify_email_description";
  static const String resendEmailLink = "resend_email_link";

  //error message
  static const String error = "error";
  static const String invalidEmail = "invalid_email";
  static const String unknownError = 'unknown_error';
  static const String noConnectionError = 'no_connection_error';
  static const String requiredFields = "required_fields";
  static const String noData = "no_data";
  static const String offline = "offline";
  static const String internetRestore = "internet_restore";
  static const String passwordFormatError = "password_format_error";
  static const String weakPasswordError = "weak_password_error";
  static const String existingEmail = "existing_email";

  //home
  static const String hello = "hello";
  static const String welcome = "welcome";
  static const String passwordHealth = "password_health";

  //bottom navigation bar
  static const String home = 'home';
  static const String menu = 'menu';
  static const String generator = 'generator';
  static const String passwords = 'passwords';

  //password generator
  static const String passwordGenerator = "password_generator";
  static const String passwordLength = "password_length";
  static const String options = 'options';
  static const String uppercaseLetters = 'uppercase_letters';
  static const String lowercaseLetters = 'lowercase_letters';
  static const String numbers = 'numbers';
  static const String specialCharacters = 'special_characters';
  static const String minimumNumbers = 'minimum_numbers';
  static const String minimumSpecial = 'minimum_special';
  static const String avoidAmbiguousCharacters = 'avoid_ambiguous_characters';
  static const String copiedSuccessfully = 'copied_successfully';
  static const String passwordType = "password_type";
  static const String passphrase = "passphrase";
  static const String numWords = "num_words";
  static const String wordSeparator = "word_separator";
  static const String capitalize = "capitalize";
  static const String includeNumber = "include_number";
  static const String history = "history";

  //password
  static const String userId = "user_id";
  static const String noteOptional = "note_optional";
  static const String note = "note";
  static const String signInLocationOrApp = "sign_in_location_or_app";
  static const String addNewPassword = "add_new_password";
  static const String editPassword = "edit_password";
  static const String generatePassword = "generate_password";
  static const String set = "set";
  static const String enterWebAddr = "enter_web_addr";
  static const String apps = "apps";
  static const String signInLocation = "sign_in_location";
  static const String addPasswordSuccessful = "add_password_successful";

  //password list
  static const String passwordListEmpty = "password_list_empty";
  static const String weakPasswordWarning = "weak_password_warning";
  static const String weakPasswordWarningMessage =
      "weak_password_warning_message";

  //setting
  static const String settings = "settings";
  static const String autoFillService = "auto_fill_service";
  static const String unlockWithBiometrics = "unlock_with_biometrics";
  static const String lock = "lock";
  static const String changeMasterPassword = "change_master_password";

  //password detail
  static const String passwordDetail = "password_detail";
  static const String deleteItem = "delete_item";
  static const String deleteConfirmMessage = "delete_confirm_message";
  static const String passwordSecurity = "password_security";
  static const String deletedPasswordSuccessfully =
      "deleted_password_successfully";
  static const String updatedPasswordSuccessfully =
      "updated_password_successfully";
}
