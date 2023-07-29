import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:password_keeper/presentation/theme/export.dart';
import 'package:zxcvbn/zxcvbn.dart';

enum PasswordStrengthLevel {
  veryWeak(color: AppColors.red, lineLength: 1 / 4),
  weak(color: AppColors.orange, lineLength: 2 / 4),
  good(color: AppColors.blue, lineLength: 3 / 4),
  strong(color: AppColors.green, lineLength: 4 / 4);

  const PasswordStrengthLevel({
    required this.color,
    required this.lineLength,
  });
  final Color color;
  final double lineLength;
}

class PasswordHelper {
  static PasswordStrengthLevel checkPasswordStrength(String password) {
    final zxcvbn = Zxcvbn();

    final result = zxcvbn.evaluate(password);

    log('Password: ${result.password}');
    log('Score: ${result.score}');
    log(result.feedback.warning ?? '');
    for (final suggestion in result.feedback.suggestions ?? []) {
      log(suggestion);
    }

    final score = result.score ?? 0.0;
    if (score <= 1.0) {
      return PasswordStrengthLevel.veryWeak;
    } else if (score <= 2.0) {
      return PasswordStrengthLevel.weak;
    } else if (score <= 3.0) {
      return PasswordStrengthLevel.good;
    } else {
      return PasswordStrengthLevel.strong;
    }
  }
}
