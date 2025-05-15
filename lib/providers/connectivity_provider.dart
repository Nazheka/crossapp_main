import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:read_the_label/services/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService;
  bool _isConnected = true;

  ConnectivityProvider(this._connectivityService) {
    _initConnectivity();
  }

  bool get isConnected => _isConnected;

  Future<void> _initConnectivity() async {
    try {
      _isConnected = await _connectivityService.isConnected();
      notifyListeners();

      _connectivityService.connectivityStream.listen((result) {
        _isConnected = result != ConnectivityResult.none;
        notifyListeners();
      });
    } catch (e) {
      print('Error initializing connectivity: $e');
      _isConnected = false;
      notifyListeners();
    }
  }
} 