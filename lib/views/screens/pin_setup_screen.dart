import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/viewmodels/pin_view_model.dart';
import 'package:read_the_label/l10n/app_localizations.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _setPin() {
    final l10n = AppLocalizations.of(context);
    
    if (_pinController.text.length != 4 || !_pinController.text.contains(RegExp(r'^[0-9]+$'))) {
      setState(() {
        _errorMessage = l10n.pinMustBe4Digits;
      });
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      setState(() {
        _errorMessage = l10n.pinsDoNotMatch;
      });
      return;
    }

    final pinViewModel = Provider.of<PinViewModel>(context, listen: false);
    pinViewModel.setPin(_pinController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setPinCode),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.enterPinCode,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: l10n.enterPinCode,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPinController,
              decoration: InputDecoration(
                labelText: l10n.confirmPinCode,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _setPin,
              child: Text(l10n.setPinCode),
            ),
          ],
        ),
      ),
    );
  }
} 