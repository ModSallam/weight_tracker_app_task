import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker_task_app/data/data.dart';

class WeightRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  WeightRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<void> addWeight({
    required WeightModel weight,
  }) async {
    try {
      await _firestore
          .collection('weight')
          .doc(_auth.currentUser!.uid)
          .collection('entries')
          .doc()
          .set(weight.toMap());
    } catch (_) {}
  }
}
