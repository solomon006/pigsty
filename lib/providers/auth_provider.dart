import 'package:delicious/models/user_model.dart';
import 'package:delicious/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _userModel != null;
  String? get error => _error;
  User? get currentUser => _authService.currentUser;
  
  // Constructor - load user data if already signed in
  AuthProvider() {
    _loadUserData();
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      if (user == null) {
        _userModel = null;
        notifyListeners();
      } else {
        _loadUserData();
      }
    });
  }
  
  // Load user data
  Future<void> _loadUserData() async {
    if (_authService.currentUser == null) return;
    
    try {
      _setLoading(true);
      _userModel = await _authService.getUserData();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      await _authService.signInWithEmailAndPassword(email, password);
      await _loadUserData();
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Register with email and password
  Future<bool> register(String name, String email, String password) async {
    try {
      _setLoading(true);
      await _authService.registerWithEmailAndPassword(email, password, name);
      await _loadUserData();
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _userModel = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }
  }
  
  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      _setLoading(true);
      await _authService.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        address: address,
      );
      await _loadUserData();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      await _authService.resetPassword(email);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Helper to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
