import 'package:flutter/material.dart';
import '../models/filme.dart';
import '../services/firestore_service.dart';

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Salvo como Quero Ver')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Marcado como Já Vi')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
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
      appBar: AppBar(title: Text(filme.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (filme.posterUrl != null)
              Center(
                child: Image.network(
                  filme.posterUrl!,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(filme.title, style: Theme.of(context).textTheme.headlineSmall),
            if (filme.voteAverage != null)
              Text('Nota: ${filme.voteAverage!.toStringAsFixed(1)}'),
            const SizedBox(height: 16),
            const Text(
              'Sinopse',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(filme.overview),
            const SizedBox(height: 24),
            if (_salvando)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _salvarQueroVer,
                    icon: const Icon(Icons.bookmark_add),
                    label: const Text('Quero Ver'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _marcarJaVi,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Já Vi'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
