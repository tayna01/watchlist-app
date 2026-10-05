import 'package:cloud_firestore/cloud_firestore.dart';

class Filme {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? releaseDate;
  final double? voteAverage;
  String? status;

  Filme({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.releaseDate,
    this.voteAverage,
    this.status,
  });

  factory Filme.fromTmdbJson(Map<String, dynamic> json) {
    return Filme(
      id: json["id"] as int,
      title: json["title"] as String,
      overview: json["overview"] as String? ?? "",
      posterPath: json["poster_path"] as String?,
      releaseDate: json["release_date"] as String?,
      voteAverage: (json["vote_average"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "overview": overview,
      "posterPath": posterPath,
      "releaseDate": releaseDate,
      "voteAverage": voteAverage,
      "status": status,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }

  factory Filme.fromFirestoreMap(Map<String, dynamic> map, {String? docId}) {
    return Filme(
      id: map["id"] as int,
      title: map["title"] as String,
      overview: map["overview"] as String? ?? "",
      posterPath: map["posterPath"] as String?,
      releaseDate: map["releaseDate"] as String?,
      voteAverage: (map["voteAverage"] as num?)?.toDouble(),
      status: map["status"] as String?,
    );
  }

  String? get posterUrl {
    if (posterPath == null) return null;
    return "https://image.tmdb.org/t/p/w500$posterPath";
  }

  String? get ano {
    final data = releaseDate;
    if (data == null || data.length < 4) return null;
    return data.substring(0, 4);
  }
}
