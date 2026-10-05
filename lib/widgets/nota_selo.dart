import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class NotaSelo extends StatelessWidget {
  const NotaSelo({super.key, required this.nota});

  final double? nota;

  @override
  Widget build(BuildContext context) {
    final nota = this.nota;
    if (nota == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.destaque,
        borderRadius: BorderRadius.circular(AppRadius.selo),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.fundo, size: 15),
          const SizedBox(width: 3),
          Text(
            nota.toStringAsFixed(1),
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.fundo,
            ),
          ),
        ],
      ),
    );
  }
}
