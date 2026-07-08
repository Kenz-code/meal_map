import 'package:flutter/material.dart';
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


class _QrScannerPageState extends State<QrScannerPage> {

  bool _loggingIn = false;


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
            const Center(
              child: CircularProgressIndicator(),
            ),

        ],
      ),
    );
  }
}