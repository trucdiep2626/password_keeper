extension StringExtensions on String {
  bool get isNullEmpty => this == null || "" == this || this == "null";
  String get cleanCurrencyFormatter {
    if (isNullEmpty) {
      return '';
    }
    return replaceAll('.', '').replaceAll(' ₫', '');
  }
}