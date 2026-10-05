import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PosterFilme extends StatelessWidget {
  const PosterFilme({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? url;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final raio = borderRadius ?? BorderRadius.circular(AppRadius.card);
    final url = this.url;

    if (url == null) {
      return _placeholder(raio);
    }

    return ClipRRect(
      borderRadius: raio,
      child: Image.network(
        url,
        fit: fit,
        gaplessPlayback: true,
        loadingBuilder: (context, child, progresso) {
          if (progresso == null) return child;
          final total = progresso.expectedTotalBytes;
          final fracao = (total == null || total == 0)
              ? 0.0
              : progresso.cumulativeBytesLoaded / total;
          return Stack(
            fit: StackFit.expand,
            children: [
              _placeholder(raio),
              Opacity(opacity: fracao.clamp(0.0, 1.0), child: child),
            ],
          );
        },
        errorBuilder: (context, erro, pilha) => _placeholder(raio),
      ),
    );
  }

  Widget _placeholder(BorderRadius raio) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.elevada,
        borderRadius: raio,
        border: Border.all(color: AppColors.borda),
      ),
      child: const Center(
        child: Icon(
          Icons.movie_rounded,
          color: AppColors.textoSecundario,
          size: 32,
        ),
      ),
    );
  }
}
