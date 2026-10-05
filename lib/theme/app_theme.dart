import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const fundo = Color(0xFF121212);
  static const superficie = Color(0xFF1F1F1F);
  static const elevada = Color(0xFF2A2A2A);
  static const destaque = Color(0xFFF5C518);
  static const textoPrimario = Color(0xFFFFFFFF);
  static const textoSecundario = Color(0xFFB3B3B3);
  static const borda = Color(0xFF303030);
  static const sucesso = Color(0xFF3FAE6A);
  static const perigo = Color(0xFFE0524B);
}

abstract final class AppRadius {
  static const card = 12.0;
  static const campo = 10.0;
  static const botao = 10.0;
  static const selo = 8.0;
}

abstract final class AppLayout {
  static const larguraMaxima = 1100.0;
  static const paddingLateral = 24.0;
  static const larguraCartao = 190.0;
}

abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    final texto = GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textoPrimario,
      displayColor: AppColors.textoPrimario,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.fundo,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.destaque,
        onPrimary: AppColors.fundo,
        secondary: AppColors.destaque,
        onSecondary: AppColors.fundo,
        surface: AppColors.superficie,
        onSurface: AppColors.textoPrimario,
        surfaceContainerLowest: AppColors.fundo,
        surfaceContainerLow: AppColors.superficie,
        surfaceContainer: AppColors.superficie,
        surfaceContainerHigh: AppColors.elevada,
        surfaceContainerHighest: AppColors.elevada,
        error: AppColors.perigo,
        onError: Colors.white,
        outline: AppColors.borda,
        outlineVariant: AppColors.borda,
      ),
      textTheme: texto.copyWith(
        displayLarge: GoogleFonts.bebasNeue(fontSize: 48),
        displayMedium: GoogleFonts.bebasNeue(fontSize: 38),
        headlineLarge: GoogleFonts.bebasNeue(fontSize: 34),
        headlineMedium: GoogleFonts.bebasNeue(fontSize: 28),
        headlineSmall: GoogleFonts.bebasNeue(fontSize: 24),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textoPrimario,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textoPrimario,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 15,
          height: 1.5,
          color: AppColors.textoPrimario,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 13.5,
          height: 1.45,
          color: AppColors.textoSecundario,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.textoSecundario,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.superficie,
        foregroundColor: AppColors.textoPrimario,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.bebasNeue(
          fontSize: 26,
          color: AppColors.textoPrimario,
        ),
        iconTheme: const IconThemeData(color: AppColors.textoPrimario),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.superficie,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.destaque.withValues(alpha: 0.16),
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final ativo = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: ativo ? AppColors.destaque : AppColors.textoSecundario,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final ativo = states.contains(WidgetState.selected);
          return GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: ativo ? FontWeight.w600 : FontWeight.w500,
            color: ativo ? AppColors.destaque : AppColors.textoSecundario,
          );
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.destaque,
        unselectedLabelColor: AppColors.textoSecundario,
        indicatorColor: AppColors.destaque,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.borda,
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.superficie,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.borda),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.destaque,
          foregroundColor: AppColors.fundo,
          disabledBackgroundColor: AppColors.elevada,
          disabledForegroundColor: AppColors.textoSecundario,
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.botao),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.destaque,
          foregroundColor: AppColors.fundo,
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.botao),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textoPrimario,
          side: const BorderSide(color: AppColors.borda),
          minimumSize: const Size(0, 48),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.botao),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.superficie,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textoSecundario,
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textoSecundario,
        ),
        prefixIconColor: AppColors.textoSecundario,
        suffixIconColor: AppColors.textoSecundario,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.campo),
          borderSide: const BorderSide(color: AppColors.borda),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.campo),
          borderSide: const BorderSide(color: AppColors.borda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.campo),
          borderSide: const BorderSide(color: AppColors.destaque, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.elevada,
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textoPrimario,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.campo),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.superficie,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.elevada,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.campo),
          side: const BorderSide(color: AppColors.borda),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textoPrimario,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.destaque,
        linearTrackColor: AppColors.elevada,
        circularTrackColor: AppColors.elevada,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borda,
        space: 1,
        thickness: 1,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          AppColors.textoSecundario.withValues(alpha: 0.45),
        ),
        radius: const Radius.circular(8),
        thickness: const WidgetStatePropertyAll(8),
      ),
      focusColor: AppColors.destaque.withValues(alpha: 0.14),
      hoverColor: AppColors.textoPrimario.withValues(alpha: 0.05),
      highlightColor: Colors.transparent,
      visualDensity: VisualDensity.standard,
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textoSecundario,
        textColor: AppColors.textoPrimario,
      ),
      iconTheme: const IconThemeData(color: AppColors.textoSecundario),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
