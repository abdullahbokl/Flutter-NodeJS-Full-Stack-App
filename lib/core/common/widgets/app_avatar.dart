import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String? fallbackInitials;
  final bool showOnlineDot;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.radius = 24,
    this.fallbackInitials,
    this.showOnlineDot = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    Widget avatar = SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceElevated,
          border: Border.all(
            color: AppColors.cardBorder.withValues(alpha: 0.6),
          ),
        ),
        child: ClipOval(
          child: _buildInner(context),
        ),
      ),
    );

    if (showOnlineDot) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.45,
              height: radius * 0.45,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      );
    }

    return onTap != null
        ? InkResponse(
            onTap: onTap,
            radius: radius + 8,
            child: avatar,
          )
        : avatar;
  }

  Widget _buildInner(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      final cacheSize = math.max(
        1,
        (radius * 2 * MediaQuery.devicePixelRatioOf(context)).round(),
      );
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        memCacheWidth: cacheSize,
        memCacheHeight: cacheSize,
        placeholder: (_, __) => ColoredBox(
          color: AppColors.primary.withValues(alpha: 0.1),
          child: Center(child: _initials()),
        ),
        errorWidget: (_, __, ___) => ColoredBox(
          color: AppColors.primary.withValues(alpha: 0.1),
          child: Center(child: _initials()),
        ),
      );
    }
    return ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(child: _initials()),
    );
  }

  Widget _initials() {
    final letters = fallbackInitials?.isNotEmpty == true
        ? fallbackInitials!
            .trim()
            .split(' ')
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : '?';
    return Text(letters,
        style: TextStyle(
            color: AppColors.primary,
            fontSize: radius * 0.55,
            fontWeight: FontWeight.w700));
  }
}
