import 'dart:async';

import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/pairing.dart';
import '../services/qr_login_service.dart';

class PairDeviceDialog extends StatefulWidget {
  const PairDeviceDialog({
    super.key,
  });

  @override
  State<PairDeviceDialog> createState() =>
      _PairDeviceDialogState();
}

class _PairDeviceDialogState
    extends State<PairDeviceDialog> {

  Pairing? _pairing;
  Timer? _timer;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generatePairing();
  }

  Future<void> _generatePairing() async {
    _timer?.cancel();

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final pairing =
      await QrLoginService.instance.createPairing();

      if (!mounted) return;

      setState(() {
        _pairing = pairing;
        _loading = false;
      });

      _startTimer();

    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (!mounted) return;

        if (_pairing!.expired) {
          _timer?.cancel();
        }

        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text(
        'Connect device',
      ),
      content: SizedBox(
        width: 250,
        child: _content(),
      ),
    );
  }


  Widget _content() {

    if (_loading) {
      return SizedBox(
        height: 220,
        width: 220,
        child: Center(
          child: CircularProgressIndicator(
            constraints: BoxConstraints(maxWidth: 20, maxHeight: 20),
          ),
        ),
      );
    }


    if (_error != null) {
      return Text(_error!);
    }


    if (_pairing!.expired) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            'QR code expired',
          ),

          const SizedBox(height: 16),

          FilledButton(
            onPressed: _generatePairing,
            child: const Text(
              'Generate new code',
            ),
          ),
        ],
      );
    }


    final qr =
        'mealmap://pair/${_pairing!.id}';


    final seconds =
        _pairing!.timeRemaining.inSeconds;


    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        QrImageView(
          data: qr,
          size: 220,
          foregroundColor: context.colorScheme.onSurfaceVariant,
        ),

        const SizedBox(height: 16),

        Text(
          'Expires in ${seconds}s',
        ),

        16.gapHeight,

        "Scan this code on your other device".text(style: context.textTheme.bodySmall, textAlign: TextAlign.center)
      ],
    );
  }
}