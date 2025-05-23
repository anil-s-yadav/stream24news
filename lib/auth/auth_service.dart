import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  User? getUser() {
    return _auth.currentUser;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      await cred.user?.sendEmailVerification();
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }
  }

  // Login with email & password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    final cleanedEmail = email.trim().toLowerCase();

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: cleanedEmail,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //  Login with Google
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception("Google sign-in failed. Please try again.");
    }
  }

  //  Update profile
  Future<void> updateUserProfile({String? name, String? photoUrl}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        if (name != null) await user.updateDisplayName(name);
        if (photoUrl != null) await user.updatePhotoURL(photoUrl);
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception("Failed to update profile. Please try again.");
    }
  }

  //  Password reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
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

  //  Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Error signing out. Please try again.");
    }
  }
}
