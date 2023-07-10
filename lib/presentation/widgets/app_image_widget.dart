import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:password_keeper/gen/assets.gen.dart';

import 'dart:typed_data';
import 'package:password_keeper/presentation/widgets/export.dart';

// /
// / Example:
// / ```
// / CommonImage(url: "https://...");
// / ```
// / or
// / ```
// / CommonImage(asset: Assets.images....);
// / ```
// / Choose this one !!!
// /
class AppImageWidget extends StatelessWidget {
  const AppImageWidget({
    super.key,
    this.onTap,
    this.asset,
    this.url,
    this.bytes,
    this.file,
    this.height,
    this.width,
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.boxShadow,
    this.margin,
    this.color,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.isCircle = false,
    this.lottieController,
    this.size,
    // ignore: prefer_asserts_with_message
  }) : assert(
  asset == null ||
      asset is AssetGenImage ||
      asset is SvgGenImage ||
      asset is String,
  );

  final VoidCallback? onTap;

  final dynamic asset;
  final String? url;
  final File? file;
  final List<int>? bytes;
  final Animation<double>? lottieController;
  final double? size;
  final double? height;
  final double? width;
  final BorderRadius borderRadius;
  final BoxBorder? border;
  final BoxShadow? boxShadow;
  final EdgeInsets? margin;

  final Color? color;
  final Color? backgroundColor;
  final BoxFit fit;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    final getHeight = size ?? height;
    final getWidth = size ?? width;

    Widget image = Assets.images..imgNoImage.image(
      color: color,
      fit: fit,
    );
    // ignore: unused_local_variable
    Widget fullImage = Assets.images.imgNoImage.image(
      color: color,
      fit: BoxFit.contain,
    );
    // ignore: prefer_final_locals
    Widget noImage = Assets.images.imgNoImage.image();

    if (url != null) {
      image = CachedNetworkImage(
        imageUrl: url!,
        color: color,
        fit: fit,
        placeholder: (_, __) {
          return AppShimmer(
            height: getHeight,
            width: getWidth,
            borderRadius: borderRadius,
          );
        },
        errorWidget: (_, __, ___) => noImage,
      );
      fullImage = CachedNetworkImage(
        imageUrl: url!,
        color: color,
        fit: BoxFit.contain,
        placeholder: (_, __) {
          return AppShimmer(
            height: getHeight,
            width: getWidth,
            borderRadius: borderRadius,
          );
        },
        errorWidget: (_, __, ___) => noImage,
      );
    } else if (bytes != null) {
      image = Image.memory(
        Uint8List.fromList(bytes!),
        color: color,
        fit: fit,
        errorBuilder: (_, __, ___) => noImage,
      );
      fullImage = Image.memory(
        Uint8List.fromList(bytes!),
        color: color,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => noImage,
      );
    } else if (file != null) {
      image = Image.file(
        file!,
        color: color,
        fit: fit,
        errorBuilder: (_, __, ___) => noImage,
      );
      fullImage = Image.file(
        file!,
        color: color,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => noImage,
      );
    } else if (asset is AssetGenImage) {
      image = (asset as AssetGenImage).image(
        color: color,
        fit: fit,
        errorBuilder: (_, __, ___) => noImage,
      );
      fullImage = (asset as AssetGenImage).image(
        color: color,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => noImage,
      );
    } else if (asset is SvgGenImage) {
      image = (asset as SvgGenImage).svg(
        color: color,
        fit: fit,
      );
      fullImage = (asset as SvgGenImage).svg(
        color: color,
      );
    } else if (asset is String &&
        !(asset as String)
            .substring((asset as String).lastIndexOf('.'))
            .contains('json')) {
      image = Image.asset(
        asset.toString(),
        color: color,
        fit: fit,
        errorBuilder: (_, __, ___) => noImage,
      );
      fullImage = Image.asset(
        asset.toString(),
        color: color,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => noImage,
      );
    }

    final child = isCircle
        ? ClipOval(child: image)
        : ClipRRect(
      borderRadius: borderRadius,
      child: image,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: border,
          color: backgroundColor,
          boxShadow: boxShadow != null ? [boxShadow!] : null,
        ),
        margin: margin,
        height: getHeight,
        width: getWidth,
        child: child,
      ),
    );
  }
}

