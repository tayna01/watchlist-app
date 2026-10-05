import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class MinhaListaScreen extends StatefulWidget {
  const MinhaListaScreen({super.key});

  @override
  State<MinhaListaScreen> createState() => _MinhaListaScreenState();
}

class _MinhaListaScreenState extends State<MinhaListaScreen> {
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minha Lista'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Quero Ver'),
              Tab(text: 'Já Vi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLista('quero_ver'),
            _buildLista('ja_vi'),
          ],
        ),
      ),
    );
  }

  Widget _buildLista(String status) {
    return StreamBuilder(
      stream: _firestore.listarPorStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ' + snapshot.error.toString()));
        }
        final lista = snapshot.data ?? [];
        if (lista.isEmpty) {
          return const Center(child: Text('Nenhum filme nesta lista'));
        }
        return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, index) {
            final item = lista[index];
            final filme = item.filme;
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
                    ? Text('Nota: ')
                    : null,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'mover') {
                      final novoStatus = status == 'quero_ver' ? 'ja_vi' : 'quero_ver';
                      await _firestore.atualizarStatus(item.docId, novoStatus);
                      if (!mounted) return;
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Movido para ')),
                        );
                      }
                    } else if (value == 'remover') {
                      await _firestore.remover(item.docId);
                      if (!mounted) return;
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removido da lista')),
                        );
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'mover',
                      child: Text(status == 'quero_ver' ? 'Marcar como Já Vi' : 'Marcar como Quero Ver'),
                    ),
                    const PopupMenuItem(
                      value: 'remover',
                      child: Text('Remover'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
