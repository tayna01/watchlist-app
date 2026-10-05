import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../theme/app_theme.dart';
import 'nota_selo.dart';
import 'poster_filme.dart';

class FilmeCartao extends StatelessWidget {
  const FilmeCartao({super.key, required this.filme, required this.onTap});

  final Filme filme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                PosterFilme(url: filme.posterUrl),
                if (filme.voteAverage != null)
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: NotaSelo(nota: filme.voteAverage),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filme.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
