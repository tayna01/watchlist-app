import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBrandBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBrandBar({super.key, this.subtitulo, this.bottom});

  final String? subtitulo;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(64 + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      titleSpacing: 16,
      bottom: bottom,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.destaque.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.campo),
            ),
            child: const Icon(
              Icons.theaters_rounded,
              color: AppColors.destaque,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Watch List App'),
              if (subtitulo != null)
                Text(
                  subtitulo!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11.5,
                    letterSpacing: 0.4,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
