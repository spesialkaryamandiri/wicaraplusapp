import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TherapyProgressService {
  TherapyProgressService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<void> recordAttempt({
    required String therapyType,
    required String category,
    required String activity,
    required bool isCorrect,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Silakan masuk kembali untuk menyimpan hasil latihan.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('therapy_progress')
        .add({
          'therapyType': therapyType,
          'category': category,
          'activity': activity,
          'isCorrect': isCorrect,
          'recordedAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAttempts(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('therapy_progress')
        .orderBy('recordedAt', descending: true)
        .limit(500)
        .snapshots();
  }
}
