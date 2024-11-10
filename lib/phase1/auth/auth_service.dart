import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math'; // To generate random referral codes

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Function to generate a random referral code
  String _generateReferralCode(String uid) {
    Random random = Random();
    String referralCode = uid.substring(0, 6) + random.nextInt(99999).toString();
    return referralCode.toUpperCase();
  }

  // Function to increment the total counters
  Future<void> _incrementTotalCounter() async {
    DocumentReference counterRef = _firestore.collection('counters').doc('totalCounters');
    
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);
      
      if (counterSnapshot.exists) {
        int currentCount = counterSnapshot.get('count') ?? 0;
        transaction.update(counterRef, {'count': currentCount + 1});
      } else {
        transaction.set(counterRef, {'count': 1});
      }
    });
  }

  // Register with Email and Password
  Future<Map<String, dynamic>?> registerWithEmailAndPassword(
      String email,
      String password,
      String country,
      String firstName,
      String lastName,
      String referralCode) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Generate referral code for the new user
      String newReferralCode = _generateReferralCode(user!.uid);

      // Check if the referral code exists in the database
      String? referrerId;
      if (referralCode.isNotEmpty) {
        var referrer = await _firestore
            .collection('users')
            .where('referralCode', isEqualTo: referralCode)
            .get();

        if (referrer.docs.isNotEmpty) {
          referrerId = referrer.docs.first.id;

          // Add new user to the referrer's referrals list
          await _firestore.collection('users').doc(referrerId).update({
            'referrals': FieldValue.arrayUnion([user.uid]),
          });
        }
      }

      // Save additional user information, including who referred them
      await _firestore.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'email': user.email,
        'country': country,
        'firstName': firstName,
        'lastName': lastName,
        'referralCode': newReferralCode,
        'referredBy': referrerId ?? '',
      });

      // Increment the total counter after successful registration
      await _incrementTotalCounter();

      return {
        'userId': user.uid,
        'email': user.email,
        'referralCode': newReferralCode,
      };
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Login with email or username
  Future<Map<String, dynamic>?> loginWithEmailOrUsername(
      String emailOrUsername, String password, String referralCode) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: emailOrUsername, password: password);
      User? user = result.user;

      if (user != null) {
        return {
          'userId': user.uid,
        };
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Check if the current user is logged in
  User? get currentUser {
    return _auth.currentUser;
  }

  // Check if email is already registered
  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      // Query Firebase Authentication for an existing user with this email
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);

      // If signInMethods is not empty, the email is already registered
      return signInMethods.isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
