import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email, 
    String password,
    String displayName,
  ) async {
    try {
      // Create user with email and password
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(displayName);
      
      // Create user document in Firestore
      await _createUserDocument(credential.user!, displayName);
      
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user, String displayName) async {
    final userModel = UserModel(
      uid: user.uid,
      email: user.email!,
      displayName: displayName,
      photoUrl: user.photoURL,
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData() async {
    if (currentUser == null) return null;
    
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      if (currentUser == null) return;

      Map<String, dynamic> data = {};
      
      if (displayName != null) {
        data['displayName'] = displayName;
        await currentUser!.updateDisplayName(displayName);
      }
      
      if (photoUrl != null) {
        data['photoUrl'] = photoUrl;
        await currentUser!.updatePhotoURL(photoUrl);
      }
      
      if (phoneNumber != null) {
        data['phoneNumber'] = phoneNumber;
      }
      
      if (address != null) {
        data['address'] = address;
      }

      if (data.isNotEmpty) {
        await _firestore.collection('users').doc(currentUser!.uid).update(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
