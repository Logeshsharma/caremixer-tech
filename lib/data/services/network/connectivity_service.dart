import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to check network connectivity with robust handling for lifecycle issues
class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();

  // Cache for connectivity state to avoid false negatives during transitions
  static bool _lastKnownState = true;
  static DateTime _lastCheckTime = DateTime.now();
  static const Duration _cacheValidityDuration = Duration(seconds: 2);

  // Debounce stream to prevent rapid state changes during player lifecycle
  static StreamController<bool>? _debouncedStreamController;
  static Timer? _debounceTimer;
  static bool _lastEmittedState = true;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  /// Check if device has network connectivity with caching
  static Future<bool> hasInternetConnection() async {
    try {
      // Use cached value if recent enough (helps during player transitions)
      final now = DateTime.now();
      if (now.difference(_lastCheckTime) < _cacheValidityDuration) {
        return _lastKnownState;
      }

      // First check if device is connected to any network
      final connectivityResult = await _connectivity.checkConnectivity();

      // If connected to WiFi, mobile, or ethernet, do a quick verification
      final isConnected =
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.ethernet);

      // Update cache
      _lastKnownState = isConnected;
      _lastCheckTime = now;

      return isConnected;
    } catch (_) {
      // On error, return last known state to avoid false negatives
      return _lastKnownState;
    }
  }

  /// Check connectivity with custom host (more thorough but can be slower)
  static Future<bool> hasConnectionToHost(String host) async {
    try {
      // First check if device is connected to any network
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      final result = await InternetAddress.lookup(host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Check if device can actually reach the internet (more thorough check)
  static Future<bool> hasActualInternetConnection() async {
    try {
      // First check basic connectivity
      if (!await hasInternetConnection()) {
        return false;
      }

      // Try multiple reliable hosts with timeout
      final hosts = ['8.8.8.8', '1.1.1.1', 'google.com'];

      for (final host in hosts) {
        try {
          final result = await InternetAddress.lookup(
            host,
          ).timeout(const Duration(seconds: 3));
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (_) {
          continue; // Try next host
        }
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// Get current connectivity status
  static Future<List<ConnectivityResult>> getConnectivityStatus() async {
    return await _connectivity.checkConnectivity();
  }

  /// Stream of connectivity changes with debouncing to handle lifecycle issues
  static Stream<bool> get onConnectivityChangedDebounced {
    _debouncedStreamController ??= StreamController<bool>.broadcast();

    // Listen to raw connectivity changes
    _connectivity.onConnectivityChanged.listen((_) async {
      // Cancel previous debounce timer
      _debounceTimer?.cancel();

      // Set up new debounce timer
      _debounceTimer = Timer(_debounceDelay, () async {
        final isConnected = await hasInternetConnection();

        // Only emit if state actually changed
        if (isConnected != _lastEmittedState) {
          _lastEmittedState = isConnected;
          _debouncedStreamController?.add(isConnected);
        }
      });
    });

    return _debouncedStreamController!.stream;
  }

  /// Stream of connectivity changes (raw, without debouncing)
  static Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// Cleanup resources
  static void dispose() {
    _debounceTimer?.cancel();
    _debouncedStreamController?.close();
    _debouncedStreamController = null;
  }
}
