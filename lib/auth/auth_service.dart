import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create User with Email & Password
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user?.sendEmailVerification();
      return cred.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Login User with Email & Password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Update User Profile (Name & Photo URL)
  Future<void> updateUserProfile({String? name, String? photoUrl}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        if (name != null) {
          await user.updateDisplayName(name);
        }
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }
        await user.reload(); // Refresh user data
      }
    } catch (e) {
      throw Exception("Failed to update profile: ${e.toString()}");
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
