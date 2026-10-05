import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

abstract final class AppSnack {
  static void mostrar(
    BuildContext context,
    String mensagem, {
    IconData icone = Icons.check_circle_rounded,
    Color cor = AppColors.sucesso,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadius.selo),
                ),
                child: Icon(icone, size: 18, color: cor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mensagem,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textoPrimario,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
