import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_map/core/services/firebase_auth_service.dart';
import 'package:meal_map/core/services/user_firestore_manager_service.dart';
import '../models/meal_idea.dart';

class IdeasFirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();
  final UserFirestoreManagerService _userFirestoreManagerService = UserFirestoreManagerService();

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  CollectionReference get _userIdeasCollection =>
      _firestore.collection('users').doc(_currentUserId).collection('mealIdeas');

  Future<void> saveMealIdea(MealIdea idea) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    await _userFirestoreManagerService.ensureUserDocumentExists();
    await _userIdeasCollection.doc(idea.id).set(idea.toMap());
  }

  Future<List<MealIdea>> loadMealIdeas() async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final querySnapshot = await _userIdeasCollection.get();
    return querySnapshot.docs
        .map((doc) => MealIdea.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteMealIdea(String id) async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    await _userIdeasCollection.doc(id).delete();
  }

  Future<void> clearMealIdeaDatabase() async {
    if (_currentUserId.isEmpty) {
      throw Exception('User is not authenticated');
    }
    final querySnapshot = await _userIdeasCollection.get();
    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}