import 'package:caremixer/utils/result.dart';

import '../../domain/models/pokemon_domian.dart';

abstract class PokemonRepository {
  Future<Result<PokemonDomian>> getPokemons(String nextSet);
}
