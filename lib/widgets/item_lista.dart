import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../theme/app_theme.dart';
import 'nota_selo.dart';
import 'poster_filme.dart';

class ItemLista extends StatelessWidget {
  const ItemLista({
    super.key,
    required this.filme,
    required this.status,
    required this.onMover,
    required this.onRemover,
  });

  final Filme filme;

  final String status;
  final VoidCallback onMover;
  final VoidCallback onRemover;

  @override
  Widget build(BuildContext context) {
    final quittingaVer = status == 'quero_ver';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 62,
              height: 92,
              child: PosterFilme(url: filme.posterUrl),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filme.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      NotaSelo(nota: filme.voteAverage),
                      const SizedBox(width: 8),
                      Text(
                        quittingaVer ? 'Quero ver' : 'Já vi',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: quittingaVer
                              ? AppColors.textoSecundario
                              : AppColors.sucesso,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _menuAcoes(quittingaVer),
          ],
        ),
      ),
    );
  }

  Widget _menuAcoes(bool quittingaVer) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded),
      tooltip: 'Ações',
      onSelected: (value) => value == 'mover' ? onMover() : onRemover(),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'mover',
          child: Row(
            children: [
              Icon(
                quittingaVer
                    ? Icons.check_circle_rounded
                    : Icons.bookmark_add_rounded,
                size: 20,
                color: AppColors.sucesso,
              ),
              const SizedBox(width: 10),
              Text(
                quittingaVer ? 'Marcar como Já Vi' : 'Marcar como Quero Ver',
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'remover',
          child: Row(
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: AppColors.perigo,
              ),
              const SizedBox(width: 10),
              Text(
                'Remover da lista',
                style: TextStyle(color: AppColors.perigo),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
