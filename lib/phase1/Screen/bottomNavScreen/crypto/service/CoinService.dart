import 'package:cloud_firestore/cloud_firestore.dart';

class CoinService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to store the counter value in Firestore
  Future<void> storeCounter(String userId, int counter) async {
    await _firestore.collection('users').doc(userId).set({
      'counter': counter,
    }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
  }

  // Method to retrieve the counter value from Firestore
  Future<int> retrieveCounter(String userId) async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
    if (snapshot.exists) {
      // return snapshot.data()?['counter'] ?? 0; // Get the counter value or default to 0
    }
    return 0; // Return 0 if the document does not exist
  }
}
