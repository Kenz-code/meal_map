import 'package:cloud_functions/cloud_functions.dart';
import 'package:meal_map/features/auth/models/pairing.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QrLoginService {
  QrLoginService._();

  static final instance = QrLoginService._();

  final FirebaseFunctions _functions =
      FirebaseFunctions.instance;

  Future<Pairing> createPairing() async {
    try {
      final callable =
      _functions.httpsCallable('createPairing');

      final result = await callable.call();

      final data = result.data as Map<String, dynamic>;

      return Pairing(
        id: data['pairingId'],
        expiresAt: DateTime.parse(
          data['expiresAt'],
        ),
      );
    } on FirebaseFunctionsException catch (e) {
      throw Exception(
        e.message ?? 'Failed to create pairing',
      );
    }
  }

  Future<void> loginWithPairing(
      String pairingId,
      ) async {

    final callable =
    _functions.httpsCallable(
      'completePairing',
    );


    final result =
    await callable.call({
      'pairingId': pairingId,
    });


    final data =
    result.data as Map<String, dynamic>;


    final token =
    data['token'] as String;


    await FirebaseAuth.instance
        .signInWithCustomToken(token);
  }
}