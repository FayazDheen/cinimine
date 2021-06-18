import 'package:intl/intl.dart';

class MovieModel {
  MovieModel({
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
  });

  var id;
  var originalLanguage;
  var originalTitle;
  var overview;
  var posterPath;
  var releaseDate;
  var title;

  static MovieModel createMovie(Map<String, dynamic> json) => MovieModel(
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"] ?? "",
        // releaseDate: DateTime.parse(json["release_date"]),
        releaseDate: json["release_date"] == null
            ? "NA"
            : new DateFormat("yyyy-MM-dd").parse(json["release_date"]),
        title: json["title"],
      );
}
