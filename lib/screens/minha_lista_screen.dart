import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_brand.dart';
import '../widgets/app_snack.dart';
import '../widgets/conteudo_limitado.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/item_lista.dart';

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
        appBar: const AppBrandBar(
          subtitulo: 'MINHA LISTA',
          bottom: TabBar(
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Quero Ver'),
              Tab(text: 'Já Vi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildLista('quero_ver'), _buildLista('ja_vi')],
        ),
      ),
    );
  }

  Widget _buildLista(String status) {
    final querVer = status == 'quero_ver';

    return StreamBuilder(
      stream: _firestore.listarPorStatus(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return EstadoVazio(
            icone: Icons.cloud_off_rounded,
            titulo: 'Não foi possível carregar a lista',
            mensagem: 'Erro: ${snapshot.error}',
            cor: AppColors.perigo,
          );
        }
        final lista = snapshot.data ?? [];
        if (lista.isEmpty) {
          return EstadoVazio(
            icone: querVer
                ? Icons.bookmark_add_rounded
                : Icons.check_circle_rounded,
            titulo: querVer
                ? 'Nada na lista "Quero Ver"'
                : 'Nada marcado como visto',
            mensagem: querVer
                ? 'Na aba Busca, abra um filme e toque em "Quero Ver" para salvar aqui.'
                : 'Quando você marcar um filme como "Já Vi", ele aparece aqui.',
            cor: querVer ? AppColors.textoSecundario : AppColors.sucesso,
          );
        }

        return ConteudoLimitado(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            itemCount: lista.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = lista[index];
              return ItemLista(
                filme: item.filme,
                status: status,
                onMover: () => _mover(item.docId, status),
                onRemover: () => _remover(item.docId),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _mover(String docId, String status) async {
    final novoStatus = status == 'quero_ver' ? 'ja_vi' : 'quero_ver';
    await _firestore.atualizarStatus(docId, novoStatus);
    final destino = novoStatus == 'ja_vi' ? 'Já Vi' : 'Quero Ver';

    if (!mounted) return;
    if (context.mounted) {
      AppSnack.mostrar(
        context,
        'Movido para $destino',
        icone: Icons.swap_horiz_rounded,
        cor: AppColors.sucesso,
      );
    }
  }

  Future<void> _remover(String docId) async {
    await _firestore.remover(docId);
    if (!mounted) return;
    if (context.mounted) {
      AppSnack.mostrar(
        context,
        'Removido da lista',
        icone: Icons.delete_outline_rounded,
        cor: AppColors.perigo,
      );
    }
  }
}
