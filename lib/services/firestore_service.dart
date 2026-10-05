import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/filme.dart';

class FirestoreService {
  final CollectionReference _filmes = FirebaseFirestore.instance.collection(
    'filmes',
  );

  Future<void> salvarComoQueroVer(Filme filme) async {
    filme.status = 'quero_ver';
    await _filmes.add(filme.toMap());
  }

  Future<void> marcarComoJaVi(Filme filme) async {
    filme.status = 'ja_vi';
    await _filmes.add(filme.toMap());
  }

  Future<void> atualizarStatus(String docId, String status) async {
    await _filmes.doc(docId).update({'status': status});
  }

  Future<void> remover(String docId) async {
    await _filmes.doc(docId).delete();
  }

  Stream<List<FilmeComId>> listarPorStatus(String status) {
    return _filmes
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return FilmeComId(
              filme: Filme.fromFirestoreMap(data),
              docId: doc.id,
            );
          }).toList();
        });
  }
}

class FilmeComId {
  final Filme filme;
  final String docId;

  FilmeComId({required this.filme, required this.docId});
}
