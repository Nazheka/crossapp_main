import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/viewmodels/pin_view_model.dart';
import 'package:read_the_label/l10n/app_localizations.dart';
import 'package:read_the_label/views/screens/home_page.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verifyPin() async {
    final l10n = AppLocalizations.of(context);
    
    if (_pinController.text.length != 4) {
      setState(() {
        _errorMessage = l10n.pleaseEnter4Digits;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final pinViewModel = Provider.of<PinViewModel>(context, listen: false);
    final isValid = pinViewModel.validatePin(_pinController.text);

    if (!isValid) {
      setState(() {
        _errorMessage = l10n.invalidPin;
        _isLoading = false;
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.enterPinCode,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _pinController,
                decoration: InputDecoration(
                  labelText: l10n.enterPinCode,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                enabled: !_isLoading,
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyPin,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(l10n.enterPinCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 