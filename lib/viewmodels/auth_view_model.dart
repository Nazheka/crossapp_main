import 'package:flutter/material.dart';
import 'package:read_the_label/services/auth_service.dart';
import 'package:read_the_label/services/connectivity_service.dart';
import 'package:read_the_label/services/pin_service.dart';
import 'package:read_the_label/viewmodels/base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  final AuthService _authService;
  final ConnectivityService _connectivityService;
  PinService? _pinService;

  set pinService(PinService service) => _pinService = service;

  AuthViewModel(this._authService, this._connectivityService);

  Future<bool> login(String email, String password) async {
    if (!await _connectivityService.isConnected()) {
      setError("No internet connection. Please connect to the internet to log in.");
      return false;
    }

    try {
      return await _authService.login(email, password);
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    if (!await _connectivityService.isConnected()) {
      setError("No internet connection. Please connect to the internet to register.");
      return false;
    }

    try {
      return await _authService.register(email, password, name);
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  Future<void> loginAsGuest() async {
    try {
      await _authService.loginAsGuest();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<bool> logout() async {
    if (!await _connectivityService.isConnected()) {
      setError("No internet connection. Please connect to the internet to log out.");
      return false;
    }

    try {
      final user = await _authService.getCurrentUser();
      await _authService.logout();
      if (_pinService != null && user != null && !(user.isGuest)) {
        await _pinService!.removePin(user.id ?? '');
      }
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      return await _authService.isLoggedIn();
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
} 