import 'package:flutter_test/flutter_test.dart';

import 'package:watchlist_flutter_firestore/models/filme.dart';

void main() {
  group('Filme', () {
    test('extrai o ano de release_date vindo da TMDB', () {
      final filme = Filme.fromTmdbJson({
        'id': 550,
        'title': 'Fight Club',
        'overview': 'Um insone insone.',
        'poster_path': '/abc.jpg',
        'release_date': '1999-10-15',
        'vote_average': 8.4,
      });

      expect(filme.ano, '1999');
      expect(filme.posterUrl, 'https://image.tmdb.org/t/p/w500/abc.jpg');
      expect(filme.voteAverage, 8.4);
    });

    test('ano e nulo quando a TMDB nao devolve a data', () {
      final filme = Filme.fromTmdbJson({
        'id': 1,
        'title': 'Sem data',
        'overview': '',
      });

      expect(filme.ano, isNull);
      expect(filme.posterUrl, isNull);
    });

    test('ano e nulo quando a data e invalida', () {
      final filme = Filme(id: 1, title: 'X', overview: '', releaseDate: '19');

      expect(filme.ano, isNull);
    });

    test('fromFirestoreMap mantem o ano e o status', () {
      final filme = Filme.fromFirestoreMap({
        'id': 7,
        'title': 'Dune',
        'overview': 'No deserto.',
        'posterPath': '/dune.jpg',
        'releaseDate': '2021-09-15',
        'voteAverage': 7.8,
        'status': 'ja_vi',
      });

      expect(filme.ano, '2021');
      expect(filme.status, 'ja_vi');
      expect(filme.posterUrl, 'https://image.tmdb.org/t/p/w500/dune.jpg');
    });
  });
}
