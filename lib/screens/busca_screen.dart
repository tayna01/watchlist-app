import 'package:flutter/material.dart';
import '../models/filme.dart';
import '../services/tmdb_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_brand.dart';
import '../widgets/conteudo_limitado.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/filme_cartao.dart';
import 'detalhes_screen.dart';

class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  State<BuscaScreen> createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final TmdbService _tmdb = TmdbService();

  final TextEditingController _controller = TextEditingController();

  List<Filme> _filmes = [];
  bool _carregando = false;
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    _carregarPopulares();
  }

  Future<void> _carregarPopulares() async {
    setState(() {
      _carregando = true;
      _buscando = false;
    });
    try {
      final populares = await _tmdb.buscarPopulares();
      setState(() {
        _filmes = populares;
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<void> _buscar() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      await _carregarPopulares();
      return;
    }
    setState(() {
      _carregando = true;
      _buscando = true;
    });
    try {
      final resultados = await _tmdb.buscarFilmes(query);
      setState(() {
        _filmes = resultados;
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _abrirDetalhes(Filme filme) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetalhesScreen(filme: filme)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBrandBar(subtitulo: 'BUSCA'),
      body: ConteudoLimitado(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'Buscar filme (título)',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                      onSubmitted: (_) => _buscar(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _buscar,
                    icon: const Icon(Icons.search_rounded, size: 20),
                    label: const Text('Buscar'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    _buscando ? 'Resultados da busca' : 'Filmes populares',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: 10),
                  if (!_carregando && _filmes.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.elevada,
                        borderRadius: BorderRadius.circular(AppRadius.selo),
                      ),
                      child: Text(
                        '${_filmes.length}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(child: _buildCorpo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_filmes.isEmpty) {
      return EstadoVazio(
        icone: Icons.search_off_rounded,
        titulo: _buscando ? 'Nenhum resultado' : 'Nada por aqui',
        mensagem: _buscando
            ? 'Tente outro título ou confira a digitação.'
            : 'A busca foi reiniciada. Digite um título para começar.',
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final colunas = (constraints.maxWidth / AppLayout.larguraCartao)
            .floor()
            .clamp(2, 7);
        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: colunas,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.58,
          ),
          itemCount: _filmes.length,
          itemBuilder: (context, index) {
            final filme = _filmes[index];
            return FilmeCartao(
              filme: filme,
              onTap: () => _abrirDetalhes(filme),
            );
          },
        );
      },
    );
  }
}
