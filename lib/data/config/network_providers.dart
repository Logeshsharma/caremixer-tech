import 'package:caremixer/data/repositories/pokemon_repository.dart';
import 'package:caremixer/data/repositories/pokemon_repository_remote.dart';
import 'package:caremixer/data/services/api/pokemon_api_service.dart';
import 'package:caremixer/data/services/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String kApiBaseUrl = 'https://pokeapi.co/api/v2/';

/// Dio client provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(baseUrl: kApiBaseUrl);
});

/// API service provider
final apiServiceProvicer = Provider<PokemonApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PokemonApiService(dioClient.dio, baseUrl: kApiBaseUrl);
});

/// Remote repository provider
final repositoryProvider = Provider<PokemonRepository>((ref) {
  final apiService = ref.watch(apiServiceProvicer);
  return PokemonRepositoryRemote(apiService: apiService);
});
