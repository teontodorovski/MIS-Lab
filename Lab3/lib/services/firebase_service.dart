import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/favorite_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  late String _userId;

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  Future<void> initialize(String userId) async {
    _userId = userId;

    // Request notification permission
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  // Add favorite to Firestore
  Future<void> addFavorite(Favorite favorite) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(favorite.mealId)
          .set(favorite.toJson());
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  // Remove favorite from Firestore
  Future<void> removeFavorite(String mealId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(mealId)
          .delete();
    } catch (e) {
      print('Error removing favorite: $e');
      rethrow;
    }
  }

  // Get all favorites from Firestore
  Future<List<Favorite>> getFavorites() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .orderBy('addedDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Favorite.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  // Check if meal is favorite
  Future<bool> isFavorite(String mealId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(mealId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  // Stream favorites (real-time updates)
  Stream<List<Favorite>> favoritesStream() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('favorites')
        .orderBy('addedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Favorite.fromJson(doc.data()))
        .toList());
  }
}
