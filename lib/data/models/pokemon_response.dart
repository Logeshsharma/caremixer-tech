import 'dart:convert';

PokemonResponse pokemonResponseFromJson(String str) =>
    PokemonResponse.fromJson(json.decode(str));

String pokemonResponseToJson(PokemonResponse data) =>
    json.encode(data.toJson());

class PokemonResponse {
  int? count;
  final String? next;
  final String? previous;
  final List<Pokemon>? results;

  PokemonResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  PokemonResponse copyWith({
    int? count,
    String? next,
    String? previous,
    List<Pokemon>? results,
  }) =>
      PokemonResponse(
        count: count ?? this.count,
        next: next ?? this.next,
        previous: previous ?? this.previous,
        results: results ?? this.results,
      );

  factory PokemonResponse.fromJson(Map<String, dynamic> json) =>
      PokemonResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Pokemon>.from(json["results"].map((x) => Pokemon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Pokemon {
  final String name;
  final String url;

  Pokemon({
    required this.name,
    required this.url,
  });

  Pokemon copyWith({
    String? name,
    String? url,
  }) =>
      Pokemon(
        name: name ?? this.name,
        url: url ?? this.url,
      );

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}
