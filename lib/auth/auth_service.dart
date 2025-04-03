import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  User? getUser() {
    User? user = _auth.currentUser;
    return user;
  }

  // Create User with Email & Password
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user?.sendEmailVerification();
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.code} - ${e.message}"); // Debugging
      throw e; // Don't wrap it in Exception(), just re-throw it
    } catch (e) {
      log("General Exception: $e");
      throw Exception("Something went wrong. Please try again.");
    }
  }

  // Login User with Email & Password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.code} - ${e.message}");
      throw e; // Don't wrap it in Exception(), just re-throw it
    } catch (e) {
      log("General Exception: $e");
      throw Exception("Something went wrong. Please try again.");
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
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException (update profile): ${e.code} - ${e.message}");
      throw e; // Throw Firebase exception directly
    } catch (e) {
      log("General Exception (update profile): $e");
      throw Exception("Failed to update profile. Please try again.");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("No account found with this email.");
      } else if (e.code == 'invalid-email') {
        throw Exception("Invalid email format. Please check again.");
      } else {
        throw Exception("Something went wrong. Try again later.");
      }
    } catch (e) {
      throw Exception("An unexpected error occurred.");
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Start Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels, return null
      if (googleUser == null) return null;

      // Retrieve Google authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in with Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      log("Google Sign-In Error: $e"); // Log error for debugging
      throw Exception("Google sign-in failed. Please try again.");
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Error signing out: $e");
      throw Exception("Error signing out. Please try again.");
    }
  }
}
