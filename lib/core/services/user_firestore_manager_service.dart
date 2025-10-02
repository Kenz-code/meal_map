import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';

class UserFirestoreManagerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  DocumentReference get _userDoc =>
      _firestore.collection('users').doc(_currentUserId);

  /// Ensures the user document exists, creates it if not.
  Future<void> ensureUserDocumentExists() async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final doc = await _userDoc.get();
    if (!doc.exists) {
      await _userDoc.set({'createdAt': FieldValue.serverTimestamp()});
    }
  }
}
