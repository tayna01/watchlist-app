import 'package:flutter/material.dart';
import '../models/filme.dart';
import '../services/tmdb_service.dart';

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
      appBar: AppBar(title: const Text('Filmes para Assistir')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Buscar filme (título)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _buscar(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _buscar, child: const Text('Buscar')),
              ],
            ),
            const SizedBox(height: 16),
            if (_buscando)
              Text(
                'Resultados da busca',
                style: Theme.of(context).textTheme.titleMedium,
              )
            else
              Text(
                'Filmes populares',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: 8),
            if (_carregando)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _filmes.length,
                  itemBuilder: (context, index) {
                    final filme = _filmes[index];
                    return Card(
                      child: ListTile(
                        leading: filme.posterUrl != null
                            ? Image.network(
                                filme.posterUrl!,
                                width: 60,
                                height: 90,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(
                                width: 60,
                                height: 90,
                                child: Icon(Icons.movie),
                              ),
                        title: Text(filme.title),
                        subtitle: filme.voteAverage != null
                            ? Text(
                                'Nota: ${filme.voteAverage!.toStringAsFixed(1)}',
                              )
                            : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _abrirDetalhes(filme),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
