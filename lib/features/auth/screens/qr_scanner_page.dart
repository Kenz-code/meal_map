import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/features/auth/widgets/progress_to_check.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/qr_login_service.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({
    super.key,
  });

  @override
  State<QrScannerPage> createState() =>
      _QrScannerPageState();
}


class _QrScannerPageState extends State<QrScannerPage> with SingleTickerProviderStateMixin {

  bool _loggingIn = false;

  bool _playSuccessAnimation = false;


  Future<void> _handleQr(String value) async {
    if (_loggingIn) return;

    if (!value.startsWith('mealmap://pair/')) {
      return;
    }

    setState(() {
      _loggingIn = true;
    });


    final pairingId =
    value.replaceFirst(
      'mealmap://pair/',
      '',
    );


    try {

      await QrLoginService.instance
          .loginWithPairing(pairingId);


      if (!mounted) return;

      setState(() {
        _playSuccessAnimation = true;
      });

      await Future.delayed(Duration(milliseconds: 900));

      Navigator.pop(context, true);


    } catch (e) {

      if (!mounted) return;

      setState(() {
        _loggingIn = false;
      });


      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan device QR',
        ),
      ),

      body: Stack(
        children: [

          MobileScanner(
            onDetect: (capture) {

              for (final barcode
              in capture.barcodes) {

                final value =
                    barcode.rawValue;


                if (value != null) {
                  _handleQr(value);
                  break;
                }
              }
            },
          ),


          if (_loggingIn)
            Center(
              child: ProgressToCheck(completed: _playSuccessAnimation)
            ),
        ],
      ),
    );
  }
}