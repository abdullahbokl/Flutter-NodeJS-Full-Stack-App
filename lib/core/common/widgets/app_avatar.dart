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
    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withOpacity(0.15),
      child: _buildInner(),
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
        ? GestureDetector(onTap: onTap, child: avatar)
        : avatar;
  }

  Widget _buildInner() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (_, __) => _initials(),
          errorWidget: (_, __, ___) => _initials(),
        ),
      );
    }
    return _initials();
  }

  Widget _initials() {
    final letters = fallbackInitials?.isNotEmpty == true
        ? fallbackInitials!.trim().split(' ')
            .take(2).map((w) => w[0].toUpperCase()).join()
        : '?';
    return Text(letters,
        style: TextStyle(
            color: AppColors.primary,
            fontSize: radius * 0.55,
            fontWeight: FontWeight.w700));
  }
}

