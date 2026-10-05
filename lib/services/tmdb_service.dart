import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/filme.dart';

class TmdbService {
  static const String _token = String.fromEnvironment('TMDB_TOKEN');

  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Filme>> buscarFilmes(String query) async {
    if (query.isEmpty) return [];
    final uri = Uri.parse('$_baseUrl/search/movie?query=$query&language=pt-BR');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;
      return results.map((e) => Filme.fromTmdbJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar filmes: ${response.statusCode}');
    }
  }

  Future<List<Filme>> buscarPopulares() async {
    final uri = Uri.parse('$_baseUrl/movie/popular?language=pt-BR');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;
      return results.map((e) => Filme.fromTmdbJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar populares: ${response.statusCode}');
    }
  }

  Future<Filme> buscarDetalhes(int id) async {
    final uri = Uri.parse('$_baseUrl/movie/$id?language=pt-BR');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $_token',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Filme.fromTmdbJson(data);
    } else {
      throw Exception('Erro ao buscar detalhes: ${response.statusCode}');
    }
  }
}
