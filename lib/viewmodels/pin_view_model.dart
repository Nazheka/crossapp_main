import 'package:flutter/material.dart';
import 'package:read_the_label/services/pin_service.dart';

class PinViewModel extends ChangeNotifier {
  final PinService _pinService;
  final String userId;
  bool _isPinEnabled = false;

  PinViewModel(this._pinService, this.userId) {
    _isPinEnabled = _pinService.hasPin(userId);
  }

  bool get isPinEnabled => _isPinEnabled;

  Future<void> setPin(String pin) async {
    if (pin.length == 4 && pin.contains(RegExp(r'^[0-9]+$'))) {
      await _pinService.setPin(userId, pin);
      _isPinEnabled = true;
      notifyListeners();
    }
  }

  Future<void> removePin() async {
    await _pinService.removePin(userId);
    _isPinEnabled = false;
    notifyListeners();
  }

  bool validatePin(String pin) {
    final savedPin = _pinService.getPin(userId);
    return savedPin == pin;
  }
} 