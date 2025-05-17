import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spa_ceylon_mobile/models/userModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user model from Firestore
  Future<UserModel?> getCurrentUserModel() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(
              doc.data() as Map<String, dynamic>, user.uid);
        }
      }
      return null;
    } catch (e) {
      print('Error getting current user model: $e');
      return null;
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailPassword({
    required String email,
    required String password,
    required String username,
    required String mobile,
    required String nationality,
    required String gender,
    required String nic,
    DateTime? birthday, // New parameter for birthday
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          username: username,
          email: email,
          mobile: mobile,
          nationality: nationality,
          gender: gender,
          nic: nic,
          photoUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          birthday: birthday, // Set birthday
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        await user.updateDisplayName(username);
        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Register error: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Unexpected error during registration: $e');
      throw e;
    }
  }

  // Sign in with email and password
  Future<UserModel?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          return UserModel.fromMap(
              doc.data() as Map<String, dynamic>, user.uid);
        } else {
          UserModel newUser = UserModel(
            uid: user.uid,
            username: user.displayName ?? '',
            email: user.email ?? '',
            mobile: '',
            nationality: '',
            gender: '',
            nic: '',
            photoUrl: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            birthday: null, // Default birthday to null for new users
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toMap());
          return newUser;
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Unexpected error during login: $e');
      throw e;
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  // Update user profile
  Future<UserModel?> updateUserProfile({
    required String uid,
    String? username,
    String? email,
    String? mobile,
    String? nationality,
    String? gender,
    String? nic,
    DateTime? birthday, // New parameter for birthday
  }) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception('User does not exist');
      }

      UserModel currentUser =
          UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);

      UserModel updatedUser = currentUser.copyWith(
        username: username,
        email: email,
        mobile: mobile,
        nationality: nationality,
        gender: gender,
        nic: nic,
        birthday: birthday, // Update birthday
      );

      await _firestore.collection('users').doc(uid).update({
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (mobile != null) 'mobile': mobile,
        if (nationality != null) 'nationality': nationality,
        if (gender != null) 'gender': gender,
        if (nic != null) 'nic': nic,
        if (birthday != null)
          'birthday': birthday, // Update birthday in Firestore
        'updatedAt': DateTime.now(),
      });

      User? user = _auth.currentUser;
      if (user != null) {
        if (username != null) {
          await user.updateDisplayName(username);
        }
        if (email != null && email != user.email) {
          await user.verifyBeforeUpdateEmail(email);
        }
      }

      return updatedUser;
    } catch (e) {
      print('Error updating user profile: $e');
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Unexpected error during password reset: $e');
      throw e;
    }
  }

  // Check if email is already registered
  Future<bool> isEmailRegistered(String email) async {
    try {
      List<String> signInMethods =
          await _auth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (e) {
      print('Error checking if email is registered: $e');
      return false;
    }
  }

  // Helper method to format Firebase exceptions into user-friendly messages
  String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}
