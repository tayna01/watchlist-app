import 'package:flutter/material.dart';
import '../models/filme.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_brand.dart';
import '../widgets/app_snack.dart';
import '../widgets/conteudo_limitado.dart';
import '../widgets/nota_selo.dart';
import '../widgets/poster_filme.dart';

class DetalhesScreen extends StatefulWidget {
  final Filme filme;

  const DetalhesScreen({super.key, required this.filme});

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  final FirestoreService _firestore = FirestoreService();
  bool _salvando = false;

  Future<void> _salvarQueroVer() async {
    setState(() {
      _salvando = true;
    });
    try {
      await _firestore.salvarComoQueroVer(widget.filme);
      if (mounted) {
        AppSnack.mostrar(
          context,
          'Salvo como Quero Ver',
          icone: Icons.bookmark_added_rounded,
          cor: AppColors.destaque,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnack.mostrar(
          context,
          'Erro ao salvar: $e',
          icone: Icons.error_outline_rounded,
          cor: AppColors.perigo,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  Future<void> _marcarJaVi() async {
    setState(() {
      _salvando = true;
    });
    try {
      await _firestore.marcarComoJaVi(widget.filme);
      if (mounted) {
        AppSnack.mostrar(
          context,
          'Marcado como Já Vi',
          icone: Icons.check_circle_rounded,
          cor: AppColors.sucesso,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnack.mostrar(
          context,
          'Erro ao salvar: $e',
          icone: Icons.error_outline_rounded,
          cor: AppColors.perigo,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filme = widget.filme;

    return Scaffold(
      appBar: const AppBrandBar(subtitulo: 'DETALHES'),
      body: ConteudoLimitado(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final ladoAlado = constraints.maxWidth >= 720;

              final poster = Container(
                width: 240,
                height: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x80000000),
                      blurRadius: 24,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: PosterFilme(url: filme.posterUrl),
              );

              final informacoes = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filme.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      NotaSelo(nota: filme.voteAverage),
                      const SizedBox(width: 10),
                      Text(
                        'Nota ${filme.voteAverage?.toStringAsFixed(1) ?? '-'} / 10',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (filme.ano != null) ...[
                        const SizedBox(width: 16),
                        Text(
                          filme.ano!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sinopse',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.destaque,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    filme.overview.isEmpty
                        ? 'Sinopse não disponível.'
                        : filme.overview,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildBotoes(),
                ],
              );

              if (ladoAlado) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    poster,
                    const SizedBox(width: 32),
                    Expanded(child: informacoes),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [poster, const SizedBox(height: 24), informacoes],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBotoes() {
    if (_salvando) {
      return const Center(child: CircularProgressIndicator());
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: _salvarQueroVer,
          icon: const Icon(Icons.bookmark_add_rounded, size: 20),
          label: const Text('Quero Ver'),
        ),
        ElevatedButton.icon(
          onPressed: _marcarJaVi,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEDEDED),
            foregroundColor: AppColors.fundo,
          ),
          icon: const Icon(
            Icons.check_rounded,
            size: 20,
            color: AppColors.sucesso,
          ),
          label: const Text('Já Vi'),
        ),
      ],
    );
  }
}
