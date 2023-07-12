/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Montserrat-Bold.ttf
  String get montserratBold => 'assets/fonts/Montserrat-Bold.ttf';

  /// File path: assets/fonts/Montserrat-ExtraBold.ttf
  String get montserratExtraBold => 'assets/fonts/Montserrat-ExtraBold.ttf';

  /// File path: assets/fonts/Montserrat-Light.ttf
  String get montserratLight => 'assets/fonts/Montserrat-Light.ttf';

  /// File path: assets/fonts/Montserrat-Medium.ttf
  String get montserratMedium => 'assets/fonts/Montserrat-Medium.ttf';

  /// File path: assets/fonts/Montserrat-Regular.ttf
  String get montserratRegular => 'assets/fonts/Montserrat-Regular.ttf';

  /// File path: assets/fonts/Montserrat-SemiBold.ttf
  String get montserratSemiBold => 'assets/fonts/Montserrat-SemiBold.ttf';

  /// List of all assets
  List<String> get values => [
        montserratBold,
        montserratExtraBold,
        montserratLight,
        montserratMedium,
        montserratRegular,
        montserratSemiBold
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  $AssetsImagesLottiesGen get lotties => const $AssetsImagesLottiesGen();
  $AssetsImagesPngGen get png => const $AssetsImagesPngGen();
  $AssetsImagesSvgGen get svg => const $AssetsImagesSvgGen();
}

class $AssetsImagesLottiesGen {
  const $AssetsImagesLottiesGen();

  /// File path: assets/images/lotties/empty.json
  String get empty => 'assets/images/lotties/empty.json';

  /// File path: assets/images/lotties/loading.json
  String get loading => 'assets/images/lotties/loading.json';

  /// List of all assets
  List<String> get values => [empty, loading];
}

class $AssetsImagesPngGen {
  const $AssetsImagesPngGen();

  /// File path: assets/images/png/img_no_image.png
  AssetGenImage get imgNoImage =>
      const AssetGenImage('assets/images/png/img_no_image.png');

  /// List of all assets
  List<AssetGenImage> get values => [imgNoImage];
}

class $AssetsImagesSvgGen {
  const $AssetsImagesSvgGen();

  /// File path: assets/images/svg/ic_camera.svg
  SvgGenImage get icCamera =>
      const SvgGenImage('assets/images/svg/ic_camera.svg');

  /// File path: assets/images/svg/ic_circle_close.svg
  SvgGenImage get icCircleClose =>
      const SvgGenImage('assets/images/svg/ic_circle_close.svg');

  /// File path: assets/images/svg/ic_done.svg
  SvgGenImage get icDone => const SvgGenImage('assets/images/svg/ic_done.svg');

  /// File path: assets/images/svg/ic_error.svg
  SvgGenImage get icError =>
      const SvgGenImage('assets/images/svg/ic_error.svg');

  /// File path: assets/images/svg/ic_login_screen.svg
  SvgGenImage get icLoginScreen =>
      const SvgGenImage('assets/images/svg/ic_login_screen.svg');

  /// File path: assets/images/svg/ic_money.svg
  SvgGenImage get icMoney =>
      const SvgGenImage('assets/images/svg/ic_money.svg');

  /// File path: assets/images/svg/ic_nav_account.svg
  SvgGenImage get icNavAccount =>
      const SvgGenImage('assets/images/svg/ic_nav_account.svg');

  /// File path: assets/images/svg/ic_nav_finance.svg
  SvgGenImage get icNavFinance =>
      const SvgGenImage('assets/images/svg/ic_nav_finance.svg');

  /// File path: assets/images/svg/ic_nav_home.svg
  SvgGenImage get icNavHome =>
      const SvgGenImage('assets/images/svg/ic_nav_home.svg');

  /// File path: assets/images/svg/ic_nav_love.svg
  SvgGenImage get icNavLove =>
      const SvgGenImage('assets/images/svg/ic_nav_love.svg');

  /// File path: assets/images/svg/ic_nav_workflow.svg
  SvgGenImage get icNavWorkflow =>
      const SvgGenImage('assets/images/svg/ic_nav_workflow.svg');

  /// File path: assets/images/svg/ic_verify_otp_screen.svg
  SvgGenImage get icVerifyOtpScreen =>
      const SvgGenImage('assets/images/svg/ic_verify_otp_screen.svg');

  /// File path: assets/images/svg/ic_wallet.svg
  SvgGenImage get icWallet =>
      const SvgGenImage('assets/images/svg/ic_wallet.svg');

  /// File path: assets/images/svg/ic_warning.svg
  SvgGenImage get icWarning =>
      const SvgGenImage('assets/images/svg/ic_warning.svg');

  /// File path: assets/images/svg/ic_workflow.svg
  SvgGenImage get icWorkflow =>
      const SvgGenImage('assets/images/svg/ic_workflow.svg');

  /// File path: assets/images/svg/loading.gif
  AssetGenImage get loading =>
      const AssetGenImage('assets/images/svg/loading.gif');

  /// List of all assets
  List<dynamic> get values => [
        icCamera,
        icCircleClose,
        icDone,
        icError,
        icLoginScreen,
        icMoney,
        icNavAccount,
        icNavFinance,
        icNavHome,
        icNavLove,
        icNavWorkflow,
        icVerifyOtpScreen,
        icWallet,
        icWarning,
        icWorkflow,
        loading
      ];
}

class Assets {
  Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
