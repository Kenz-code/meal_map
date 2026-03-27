import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:meal_map/core/services/user_firestore_manager_service.dart';
import 'package:meal_map/features/home/models/meal_data.dart';

class MealsFirestoreDatasource {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance
  final AuthService _auth = AuthService();

  // User Firestore manager
  final UserFirestoreManagerService _userFirestoreManagerService = UserFirestoreManagerService();

  /// Get the current user's UID
  String get _currentUserId => _auth.currentUser?.uid ?? '';

  /// Get the user's meals subcollection reference
  CollectionReference get _userMealsCollection =>
      _firestore.collection('users').doc(_currentUserId).collection('meals');

  /// Save a meal to the current user's meals subcollection
  Future<void> saveMeal(MealData mealData) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    await _userFirestoreManagerService.ensureUserDocumentExists();
    await _userMealsCollection.doc(mealData.getID()).set(mealData.toMap());
  }

  Future<void> deleteMeal(String id) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }

    try {
      await _userMealsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete meal: $e');
    }
  }

  /// Load a meal from the current user's meals subcollection by ID
  Future<MealData> loadMeal(String id) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final docSnapshot = await _userMealsCollection.doc(id).get();
    if (docSnapshot.exists) {
      return MealData.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('Meal with ID $id not found');
    }
  }

  /// Load all meals from the current user's meals subcollection
  Future<List<MealData>> loadAllMeals() async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final querySnapshot = await _userMealsCollection.get();
    return querySnapshot.docs
        .map((doc) => MealData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
