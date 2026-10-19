import 'package:connectivity_plus/connectivity_plus.dart';

/// Contract for checking device network connectivity.
abstract class NetworkInfo {
  /// Returns `true` when at least one active network interface is available.
  Future<bool> get isConnected;
}

/// Concrete implementation backed by [Connectivity] from `connectivity_plus`.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  const NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();

    // `checkConnectivity` returns a List<ConnectivityResult> in v6+.
    // The device is "connected" when at least one result is not `none`.
    return results.any(
      (result) => result != ConnectivityResult.none,
    );
  }
}
