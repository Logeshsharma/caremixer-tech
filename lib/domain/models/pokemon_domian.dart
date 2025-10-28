import 'package:caremixer/data/models/pokemon_response.dart';

class PokemonDomian {
  final List<Pokemon> pokemon;
  final String cursor;

  const PokemonDomian(this.pokemon, this.cursor);
}
