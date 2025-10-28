import 'package:caremixer/data/models/pokemon_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'pokemon_api_service.g.dart';

/// Pokemon API service using Retrofit and Dio
@RestApi()
abstract class PokemonApiService {
  factory PokemonApiService(Dio dio, {String baseUrl}) = _PokemonApiService;

  /// Get pokemon
  /// https://pokeapi.co/api/v2/pokemon?offset=20&limit=10
  @GET('pokemon?{offestAndLimit}')
  Future<PokemonResponse> getPokemons(
      @Path('offestAndLimit') String offestAndLimit);
}
