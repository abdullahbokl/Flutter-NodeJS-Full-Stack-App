import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../utils/app_colors.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.85);
    final fg = isSelected ? Colors.white : AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            left: 12, right: onRemove != null ? 4 : 12, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    color: fg, fontSize: 13, fontWeight: FontWeight.w500)),
            if (onRemove != null) ...[
              const SizedBox(width: 2),
              GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.close_rounded, size: 16, color: fg),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
