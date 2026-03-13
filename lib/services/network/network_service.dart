import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:puntgpt_nick/core/helper/log_helper.dart';
import 'package:puntgpt_nick/main.dart';

/// Handles network connectivity state for the app.
/// Call [init] once at app start; use [recheck] for manual refresh (e.g. "Try again").
class NetworkService {
  NetworkService._();

  static final NetworkService instance = NetworkService._();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _initialized = false;

  /// Current connectivity. Updated by [init] and [onConnectivityChanged].
  ValueNotifier<bool> get isConnected => isNetworkConnected;

  /// Initializes the service: sets initial state and listens to connectivity changes.
  /// Safe to call multiple times; subsequent calls are no-ops.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final results = await Connectivity().checkConnectivity();
    _updateFromConnectivity(results);
    _subscription = Connectivity().onConnectivityChanged.listen(_updateFromConnectivity);
    Logger.info("NetworkService initialized; connected: ${isNetworkConnected.value}");
  }

  void _updateFromConnectivity(List<ConnectivityResult> results) {
    final connected = !results.contains(ConnectivityResult.none);
    if (isNetworkConnected.value != connected) {
      isNetworkConnected.value = connected;
      Logger.info("Network changed: connected=$connected");
    }
  }

  /// Manually recheck connectivity (e.g. from "Try again" in offline UI).
  Future<void> recheck() async {
    final results = await Connectivity().checkConnectivity();
    _updateFromConnectivity(results);
  }

  /// Stops listening. Optional; use for tests or explicit cleanup.
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
