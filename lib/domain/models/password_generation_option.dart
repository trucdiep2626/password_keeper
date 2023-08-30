import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/password_helper.dart';

class PasswordGenerationOptions {
  bool? useUppercase;
  bool? useLowercase;
  bool? useNumbers;
  bool? useSpecial;
  bool? avoidAmbiguous;
  int? pwdLength;
  int? minNumbers;
  int? minSpecial;
  int? minUppercase;
  int? minLowercase;
  int? numWords;
  String? wordSeparator;
  bool? capitalize;
  bool? includeNumber;
  PasswordType? type;

  PasswordGenerationOptions({
    this.useUppercase = true,
    this.minUppercase = 0,
    this.useLowercase = true,
    this.minLowercase = 0,
    this.useNumbers = true,
    this.useSpecial = false,
    this.avoidAmbiguous = true,
    this.pwdLength = 14,
    this.minNumbers = 1,
    this.minSpecial = 1,
    this.numWords = 3,
    this.wordSeparator = '-',
    this.capitalize = false,
    this.includeNumber = false,
    this.type = PasswordType.password,
  });

  PasswordGenerationOptions copyWith({PasswordGenerationOptions? option}) =>
      PasswordGenerationOptions(
        useLowercase: option?.useLowercase ?? useUppercase,
        useNumbers: option?.useNumbers ?? useNumbers,
        useSpecial: option?.useSpecial ?? useSpecial,
        useUppercase: option?.useUppercase ?? useUppercase,
        pwdLength: option?.pwdLength ?? pwdLength,
        minLowercase: option?.minLowercase ?? minLowercase,
        minNumbers: option?.minNumbers ?? minNumbers,
        minSpecial: option?.minSpecial ?? minSpecial,
        minUppercase: option?.minUppercase ?? minUppercase,
        numWords: option?.numWords ?? numWords,
        wordSeparator: option?.wordSeparator ?? wordSeparator,
        capitalize: option?.capitalize ?? capitalize,
        includeNumber: option?.includeNumber ?? includeNumber,
        avoidAmbiguous: option?.avoidAmbiguous ?? avoidAmbiguous,
        type: option?.type ?? type,
      );

  PasswordGenerationOptions.fromJson(Map<String, dynamic> json) {
    useLowercase = json['use_lowercase'];
    useUppercase = json['use_uppercase'];
    useSpecial = json['use_special'];
    useNumbers = json['use_numbers'];
    minNumbers = json['min_numbers'];
    minSpecial = json['min_special'];
    minUppercase = json['min_uppercase'];
    minLowercase = json['min_lowercase'];
    avoidAmbiguous = json['avoid_ambiguous'];
    pwdLength = json['pwd_length'];
    includeNumber = json['include_number'];
    capitalize = json['capitalize'];
    wordSeparator = json['word_separator'];
    numWords = json['num_words'];
    type = PasswordHelper.getPasswordTypeFromName(json['type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['use_lowercase'] = useLowercase;
    data['use_numbers'] = useNumbers;
    data['use_special'] = useSpecial;
    data['use_uppercase'] = useUppercase;
    data['min_lowercase'] = minLowercase;
    data['min_uppercase'] = minUppercase;
    data['min_special'] = minSpecial;
    data['min_numbers'] = minNumbers;
    data['avoid_ambiguous'] = avoidAmbiguous;
    data['word_separator'] = wordSeparator;
    data['capitalize'] = capitalize;
    data['num_words'] = numWords;
    data['pwd_length'] = pwdLength;
    data['include_number'] = includeNumber;
    data['type'] = type?.name;
    return data;
  }

  // void enforcePolicy({PasswordGeneratorPolicyOptions? enforcedPolicyOptions}) {
  //   if (enforcedPolicyOptions == null) {
  //     return;
  //   }
  //
  //   if (pwdLength < enforcedPolicyOptions.minLength) {
  //     pwdLength = enforcedPolicyOptions.minLength;
  //   }
  //
  //   if (enforcedPolicyOptions.useUppercase) {
  //     useUppercase = true;
  //   }
  //
  //   if (enforcedPolicyOptions.useLowercase) {
  //     useLowercase = true;
  //   }
  //
  //   if (enforcedPolicyOptions.useNumbers) {
  //     useNumbers = true;
  //   }
  //
  //   if (minNumbers < enforcedPolicyOptions.numberCount) {
  //     minNumbers = enforcedPolicyOptions.numberCount;
  //   }
  //
  //   if (enforcedPolicyOptions.useSpecial) {
  //     useSpecial = true;
  //   }
  //
  //   if (minSpecial < enforcedPolicyOptions.specialCount) {
  //     minSpecial = enforcedPolicyOptions.specialCount;
  //   }
  //
  //   // Must normalize these fields because the receiving call expects all options to pass the current rules
  //   if (minSpecial + minNumbers > pwdLength) {
  //     minSpecial = pwdLength - minNumbers;
  //   }
  //
  //   if (numWords < enforcedPolicyOptions.minNumberOfWords) {
  //     numWords = enforcedPolicyOptions.minNumberOfWords;
  //   }
  //
  //   if (enforcedPolicyOptions.capitalize) {
  //     capitalize = true;
  //   }
  //
  //   if (enforcedPolicyOptions.includeNumber) {
  //     includeNumber = true;
  //   }
  //
  //   // Force default type if password/passphrase selected via policy
  //   // if (enforcedPolicyOptions.DefaultType == TYPE_PASSWORD ||
  //   //     enforcedPolicyOptions.DefaultType == TYPE_PASSPHRASE) {
  //   //   Type = enforcedPolicyOptions.DefaultType;
  //   // }
  // }
}
