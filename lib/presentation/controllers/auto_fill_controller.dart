import 'package:flutter/services.dart';
import 'package:flutter_autofill_service/flutter_autofill_service.dart';
import 'package:get/get.dart';
import 'package:password_keeper/common/constants/enums.dart';
import 'package:password_keeper/common/utils/app_utils.dart';
import 'package:password_keeper/common/utils/translations/app_translations.dart';
import 'package:password_keeper/domain/models/password_model.dart';
import 'package:password_keeper/presentation/controllers/mixin/mixin_controller.dart';
import 'package:password_keeper/presentation/widgets/export.dart';

class AutofillController extends GetxController with MixinController {
  static const _autofillMethodChannel =
      MethodChannel('kma.dieptt.password_keeper/autofill');
  final _autofillService = AutofillService();
  bool? forceInteractive;
  AutofillMetadata? androidMetadata;
  Rx<AutofillState> autofillState = AutofillState.initial.obs;

  RxBool enableAutofillService = false.obs;
  RxBool offerToSavePassword = true.obs;

  Future<void> refreshAutofilll() async {
    logger('refreshAutofilll');
    if (GetPlatform.isIOS) {
      ///TODO: implement for iOS
      return;
    }
    final available = await _autofillService.hasAutofillServicesSupport;
    final enabled = available
        ? await _autofillService.status == AutofillServiceStatus.enabled
        : false;
    if (!available) {
      autofillState.value = AutofillState.missing;
      return;
    }

    bool autofillRequested = await _autofillService.fillRequestedAutomatic;
    bool autofillForceInteractive =
        await _autofillService.fillRequestedInteractive;
    final androidMetadata = await _autofillService.autofillMetadata;
    logger('androidMetadata $androidMetadata');
    bool saveRequested = androidMetadata?.saveInfo != null;

    offerToSavePassword.value =
        (await _autofillService.preferences).enableSaving;

    if (!autofillRequested && !autofillForceInteractive && !saveRequested) {
      enableAutofillService.value = enabled;
      autofillState.value = AutofillState.available;
      return;
    }
    //TODO:f: should below be here? or after potential emit of autofill request for filling?
    // if (state is AutofillSaved) {
    //   emit(AutofillAvailable(enabled));
    //   return;
    // }
    if (saveRequested) {
      autofillState.value = AutofillState.saving;
      this.androidMetadata = androidMetadata;
      return;
    }

    if (androidMetadata == null) {
      throw Exception(
          'Android failed to provide the necessary autofill information.');
    }

    // we only call this cubit's function if we have some sort of intent relating to the
    // autofill service so we can now assume the user is asking for us to autofill another app/site
    autofillState.value = AutofillState.requested;
    enableAutofillService.value = true;
    this.androidMetadata = androidMetadata;
    forceInteractive = autofillForceInteractive;

    logger('------------${autofillState.value}-----------$forceInteractive');
  }

  Future<void> finishSaving() async {
    if (autofillState.value == AutofillState.saving ||
        autofillState.value == AutofillState.saved) {
      //    emit(AutofillSaved((state as AutofillModeActive).androidMetadata));
      autofillState.value = AutofillState.saved;
      await _autofillService.onSaveComplete();
    }
  }

  Future<void> setSavingPreference(value) async {
    final prefs = await _autofillService.preferences;

    offerToSavePassword.value = value;
    await _autofillService.setPreferences(AutofillPreferences(
      enableDebug: prefs.enableDebug,
      enableSaving: value,
    ));
  }

  Future<bool> autofillWithList(List<PasswordItem> passwords) async {
    if (androidMetadata == null) {
      return false;
    }

    // final androidMetadata = (state as AutofillRequested).androidMetadata;
    if (shouldIgnoreRequest(androidMetadata!)) {
      await _autofillService.resultWithDatasets(null);
      return true;
    }

    final matchingEntries = _findMatches(androidMetadata!, passwords);
    if (matchingEntries.isNotEmpty) {
      // Limited to 10 results due to Android Parcelable bugs. Totally arbitrary but we have to start somewhere.
      // Autofill library may further reduce the number if the device IME requests fewer than 11 results
      final datasets = matchingEntries.take(10).map(entryToPwDataset).toList();
      final response = await _autofillService.resultWithDatasets(datasets);
      logger('resultWithDatasets $response');
      return true; // kinda pointless since Android will kill us shortly but meh
    } else {
      return false;
    }
  }

  bool shouldIgnoreRequest(AutofillMetadata androidMetadata) {
    bool ignoreRequest = false;
    if (androidMetadata.packageNames.length > 1) {
      logger(
          "Multiple package names found for autofill. We will ignore this autofill request because we don't know why this can happen or whether we can trust the claimed names.");
      ignoreRequest = true;
    }
    if (androidMetadata.webDomains.length > 1) {
      logger(
          "Multiple domains found for autofill. We will ignore this autofill request because we don't know why this can happen or whether we can trust the claimed domains.");
      ignoreRequest = true;
    }
    if ((androidMetadata.webDomains.firstOrNull?.domain.isEmpty ?? true) &&
        (androidMetadata.packageNames.firstOrNull?.isEmpty ?? true)) {
      logger(
          'Supplied domain is empty and no packageName was found. We will ignore this autofill request.');
      ignoreRequest = true;
    }
    if (androidMetadata.packageNames.firstOrNull != null &&
        _excludedPackages.contains(androidMetadata.packageNames.firstOrNull)) {
      logger(
          'Supplied packageName is on our exclude list. We will ignore this autofill request.');
      ignoreRequest = true;
    }
    return ignoreRequest;
  }

  PwDataset entryToPwDataset(PasswordItem item) => PwDataset(
        label: item.userId ?? '',
        username: item.userId ?? '',
        password: item.password ?? '',
      );

  void autofillInstantly(PasswordItem passwordItem) async {
    final dataset = entryToPwDataset(passwordItem);
    final response = await _autofillService.resultWithDataset(
      label: dataset.label,
      username: dataset.username,
      password: dataset.password,
    );
    logger('resultWithDataset $response');
  }

  void autofillWithListOfOneEntry(PasswordItem passwordItem) async {
    final dataset = entryToPwDataset(passwordItem);
    final response = await _autofillService.resultWithDatasets([dataset]);
    logger('resultWithDatasets $response');
  }

  static final Set<String> _excludedPackages = <String>{
    'kma.dieptt.password_keeper',
    'android',
    'com.android.settings',
    'com.oneplus.applocker',
  };

  List<PasswordItem> _findMatches(
      AutofillMetadata androidMetadata, List<PasswordItem> current) {
    if (androidMetadata.webDomains.isEmpty) {
      return _findMatchesByPackageName(
        androidMetadata: androidMetadata,
        current: current,
      );
    } else {
      return _findMatchesByDomain(
        androidMetadata: androidMetadata,
        current: current,
      );
    }
  }

  List<PasswordItem> _findMatchesByPackageName(
      {required AutofillMetadata androidMetadata,
      required List<PasswordItem> current}) {
    final matches = <PasswordItem>[];
    matches.addAll(current.where((entry) => androidMetadata.packageNames.first
        .toUpperCase()
        .contains((entry.androidPackageName ?? '').toUpperCase())));
    return matches;
  }

  List<PasswordItem> _findMatchesByDomain(
      {required AutofillMetadata androidMetadata,
      required List<PasswordItem> current}) {
    // Android only provides us with the host and scheme (in 9+) so compared to Kee,
    // we can't apply the same level of control over which entries we consider a match.
    // Old versions of Android don't tell us the scheme so we have to assume it is
    // https otherwise we'll rarely be able to match any entries.
    final requestedUrl =
        "${androidMetadata.webDomains.firstOrNull?.scheme ?? 'https'}://${androidMetadata.webDomains.firstOrNull?.domain ?? ''}"
            .trim();
    //
    // // Apparently Android never supplies us with a port so this is the best we can do
    // final hostname = requestedUrl?.publicSuffixUrl.sourceUrl.host;
    //
    // final registrableDomain = requestedUrl?.publicSuffixUrl.domain;
    // final scheme = requestedUrl?.publicSuffixUrl.sourceUrl.scheme;

    final matches = <PasswordItem>[];

    current.forEach((element) {
      if (requestedUrl
          .toUpperCase()
          .contains((element.signInLocation ?? '').toUpperCase())) {
        matches.add(element);
      }
    });
    //
    // if (hostname == null || registrableDomain == null || scheme == null) {
    //   l.e("Android supplied a WebDomain we can't understand. Please report the exact web page you encounter this error on so we can see if it is possible to add support for autofilling this in future.");
    //   return matches;
    // }
    // final matchAccuracyDomainOverride = MatchAccuracy.values.singleWhereOrNull(
    //     (val) =>
    //         val.name ==
    //         current.body.meta.browserSettings
    //             .matchedURLAccuracyOverrides[registrableDomain]);
    //
    // matches.addAll(current.body.rootGroup
    //     .getAllEntries(enterRecycleBin: false)
    //     .values
    //     .where((entry) {
    //   if (entry.browserSettings.hide) {
    //     return false;
    //   }
    //   bool isAMatch = false;
    //   var minimumMatchAccuracy = matchAccuracyDomainOverride ??
    //       entry.browserSettings.minimumMatchAccuracy;
    //
    //   final matchPatterns = entry.browserSettings.includeUrls.toList();
    //   final primaryUrlString = entry.getString(KdbxKeyCommon.URL)?.getText();
    //
    //   if (primaryUrlString != null) {
    //     matchPatterns.add(primaryUrlString);
    //   }
    //   for (var pattern in matchPatterns) {
    //     if (urlsMatch(pattern, minimumMatchAccuracy, scheme, hostname,
    //         registrableDomain)) {
    //       isAMatch = true;
    //       break;
    //     }
    //   }
    //
    //   if (isAMatch) {
    //     for (var pattern in entry.browserSettings.excludeUrls) {
    //       if (urlsMatch(pattern, minimumMatchAccuracy, scheme, hostname,
    //           registrableDomain)) {
    //         isAMatch = false;
    //         break;
    //       }
    //     }
    //   }
    //
    //   return isAMatch;
    // }));
    return matches;
  }

  // @visibleForTesting
  // bool urlsMatch(Pattern pattern, MatchAccuracy minimumMatchAccuracy,
  //     String scheme, String hostname, String registrableDomain) {
  //   Pattern testValue;
  //   if (pattern is String) {
  //     final testUrl = urls.parse(pattern.trim());
  //     if (testUrl == null) {
  //       // If the user has not supplied a valid URL, we cannot safely permit it to match anything
  //       return false;
  //     }
  //     if (scheme == 'http' &&
  //         testUrl.publicSuffixUrl.sourceUrl.scheme == 'https') {
  //       // Prevent matching secure URLs in entries with an insecure version of the website but not vice-versa
  //       return false;
  //     }
  //
  //     // If user has requested Exact, we use Hostname matching instead since it is stricter than Domain, but unfortunately
  //     // we don't have the required information from Android to be able to perform the exact match the user requested.
  //     if (minimumMatchAccuracy == MatchAccuracy.Domain) {
  //       testValue = testUrl.publicSuffixUrl.domain ??
  //           testUrl.publicSuffixUrl.sourceUrl.host;
  //     } else {
  //       testValue = testUrl.publicSuffixUrl.sourceUrl.host;
  //     }
  //   } else {
  //     testValue = pattern;
  //   }
  //
  //   if (minimumMatchAccuracy == MatchAccuracy.Domain) {
  //     if (testValue.allMatches(registrableDomain).firstOrNull != null) {
  //       return true;
  //     }
  //   } else {
  //     if (testValue.allMatches(hostname).firstOrNull != null) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  bool isAutofilling() => autofillState.value == AutofillState.requested;
  bool isAutofillSaving() => autofillState.value == AutofillState.saving;

  String get selectItemToFill =>
      '${TranslationConstants.selectItemToFill.tr} ${androidMetadata?.webDomains.firstOrNull?.domain ?? androidMetadata?.packageNames.firstOrNull ?? 'app/website'}';

  Future<void> onChangedAutofillService() async {
    logger('Starting autofill enable request.');
    final response = await _autofillService.requestSetAutofillService();
    logger('autofill enable request finished $response');
    final available = await _autofillService.hasAutofillServicesSupport;
    final enabled = available
        ? await _autofillService.status == AutofillServiceStatus.enabled
        : false;
    if (!available) {
      if (Get.context != null) {
        showTopSnackBar(Get.context!,
            message: TranslationConstants.unsupportedAutofill.tr);
        autofillState.value == AutofillState.missing;
      }
    } else if (enabled) {
      if (Get.context != null && !enableAutofillService.value) {
        showTopSnackBar(Get.context!,
            message: TranslationConstants.enableAutofill.tr);
      }
      enableAutofillService.value = true;
      autofillState.value == AutofillState.available;
      //  await setSavingPreference(true);
    } else {
      if (Get.context != null && enableAutofillService.value) {
        showTopSnackBar(Get.context!,
            message: TranslationConstants.disableAutofill.tr);
      }
      enableAutofillService.value = false;
      autofillState.value == AutofillState.available;
    }
  }

  @override
  void onReady() {
    super.onReady();
    refreshAutofilll();
  }
}
