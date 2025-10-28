import 'package:caremixer/data/repositories/pokemon_repository.dart';
import 'package:caremixer/data/services/api/pokemon_api_service.dart';
import 'package:caremixer/data/services/network/connectivity_service.dart';
import 'package:caremixer/data/services/network/network_exceptions.dart';
import 'package:caremixer/domain/models/pokemon_domian.dart';
import 'package:caremixer/utils/result.dart';
import 'package:dio/dio.dart';

class PokemonRepositoryRemote implements PokemonRepository {
  final PokemonApiService _apiService;

  PokemonRepositoryRemote({required PokemonApiService apiService})
      : _apiService = apiService;

  @override
  Future<Result<PokemonDomian>> getPokemons(String nextSet) async {
    try {
      // Check network connectivity first
      final hasConnection = await ConnectivityService.hasInternetConnection();
      if (!hasConnection) {
        // Try a more thorough check as fallback
        final hasActualConnection =
            await ConnectivityService.hasActualInternetConnection();
        if (!hasActualConnection) {
          return Result.error(
            Exception(
              'No internet connection. Please check your network and try again.',
            ),
          );
        }
      }

      final pokemonResponse = await _apiService.getPokemons(nextSet);

      return Result.ok(PokemonDomian(pokemonResponse.results ?? [],
          pokemonResponse.next ?? 'offset=0&limit=10'));
    } on DioException catch (e) {
      return Result.error(_handleDioException(e));
    } catch (e) {
      return Result.error(
        Exception('Something went wrong. Please try again later.'),
      );
    }
  }

  /// Handle Dio exceptions and convert to user-friendly messages
  Exception _handleDioException(DioException e) {
    if (e.error is NetworkException) {
      final networkException = e.error as NetworkException;
      return Exception(networkException.message);
    }

    // Fallback error handling
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Request timeout. Please check your connection and try again.',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Content not found.');
        } else if (statusCode == 500) {
          return Exception('Server error. Please try again later.');
        }
        return Exception('Something went wrong. Please try again later.');

      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');

      case DioExceptionType.connectionError:
        return Exception(
          'No internet connection. Please check your network and try again.',
        );

      default:
        return Exception('Something went wrong. Please try again later.');
    }
  }
}
