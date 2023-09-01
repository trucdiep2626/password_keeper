class PasswordGeneratorPolicyOptions {
  //  String defaultType  ;
  int minLength;
  bool useUppercase;
  bool useLowercase;
  bool useNumbers;
  int numberCount;
  bool useSpecial;
  int specialCount;
  int minNumberOfWords;
  bool capitalize;
  bool includeNumber;

  PasswordGeneratorPolicyOptions({
    required this.minLength,
    required this.useUppercase,
    required this.useLowercase,
    required this.useNumbers,
    required this.numberCount,
    required this.useSpecial,
    required this.specialCount,
    required this.minNumberOfWords,
    required this.capitalize,
    required this.includeNumber,
  });

  bool inEffect() =>
      //DefaultType != string.Empty ||
      minLength > 0 ||
      numberCount > 0 ||
      specialCount > 0 ||
      useUppercase ||
      useLowercase ||
      useNumbers ||
      useSpecial ||
      minNumberOfWords > 0 ||
      capitalize ||
      includeNumber;
}
