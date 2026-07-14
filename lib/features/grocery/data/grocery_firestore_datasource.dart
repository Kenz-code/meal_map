import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:meal_map/core/services/user_firestore_manager_service.dart';
import 'package:meal_map/features/grocery/models/grocery_item.dart';

class GroceryFirestoreDatasource {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance
  final AuthService _auth = AuthService();

  // User Firestore manager
  final UserFirestoreManagerService _userFirestoreManagerService = UserFirestoreManagerService.instance;

  /// Get the current user's UID
  String get _currentUserId => _auth.currentUser?.uid ?? '';

  /// Get the user's groceries subcollection reference
  CollectionReference get _userGroceryCollection =>
      _firestore.collection('users').doc(_currentUserId).collection('grocery');

  /// Save a grocery to the current user's groceries subcollection
  Future<void> saveGrocery(GroceryItem groceryItem) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    await _userFirestoreManagerService.ensureUserDocumentExists();
    await _userGroceryCollection.doc(groceryItem.id).set(groceryItem.toMap());
  }

  /// Load all groceries from the current user's groceries subcollection
  Future<List<GroceryItem>> loadAllGroceries() async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final querySnapshot = await _userGroceryCollection.get();
    return querySnapshot.docs
        .map((doc) => GroceryItem.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateGroceryCrossedOff(String id, bool crossedOff) async {
    final docRef = _userGroceryCollection.doc(id);
    await docRef.update({'crossedOff': crossedOff});
  }
}
