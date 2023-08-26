import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

abstract class StringValue {
  /// retrieves the (decrypted) stored value.
  String getText();
}

class PlainValue implements StringValue {
  PlainValue(this.text);

  final String text;

  @override
  String getText() {
    return text;
  }

  @override
  String toString() {
    return 'PlainValue{text: $text}';
  }

  @override
  bool operator ==(dynamic other) => other is PlainValue && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

class ProtectedValue extends PlainValue {
  ProtectedValue(String text) : super(text);

  factory ProtectedValue.fromString(String value) {
    return ProtectedValue(value);
  }

  Uint8List get binaryValue => utf8.encode(text) as Uint8List;

  Uint8List get hash => sha256.convert(binaryValue).bytes as Uint8List;
}
