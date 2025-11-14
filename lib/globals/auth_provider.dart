import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/models/user_model.dart';
import 'package:building_site_build_by_vishal/globals/demo_data.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:building_site_build_by_vishal/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _init();
  }

  factory AuthProvider.of(BuildContext context, {bool listen = false}) {
    return Provider.of<AuthProvider>(context, listen: listen);
  }

  final FirebaseService _firebaseService = FirebaseService();
  UserModel? _currentUser;

  bool _isLoading = false;

  String? _errorMessage;

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        final userModel = await _firebaseService.getUser(firebaseUser.uid);
        if (userModel != null) {
          _currentUser = userModel;
          notifyListeners();
        }
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  UserModel? get currentUser {
    return _currentUser;
  }

  bool get isLoading {
    return _isLoading;
  }

  String? get errorMessage {
    return _errorMessage;
  }

  bool get isAuthenticated {
    return _currentUser != null;
  }

  bool get isOwner {
    return _currentUser?.role == 'owner';
  }

  bool get isWorker {
    return _currentUser?.role == 'worker';
  }

  Future<bool> signIn(
    BuildContext context,
    String email,
    String password,
    ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Try Firebase Auth first
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        final userModel = await _firebaseService.getUser(credential.user!.uid);
        if (userModel != null) {
          _currentUser = userModel;
          final dataProvider = DataProvider.of(context, listen: false);
          await dataProvider.loadData(_currentUser!);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      // Fallback to demo data for backward compatibility
      final normalizedEmail = DemoData.normalizeEmail(email);
      final storedPassword = DemoData.passwordForEmail(normalizedEmail);
      final user = DemoData.userForEmail(normalizedEmail);

      if (storedPassword == null ||
          user == null ||
          storedPassword != password) {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = user;
      final dataProvider = DataProvider.of(context, listen: false);
      final String ownerIdForSeed =
          user.role == 'owner' ? user.id! : DemoData.primaryOwner.id!;
      dataProvider.initializeMockData(ownerIdForSeed);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Authentication failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    List<String>? skills,
    double? hourlyRate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Create Firebase Auth user
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        final userModel = UserModel(
          id: credential.user!.uid,
          name: name,
          email: email.trim(),
          role: role,
          skills: skills,
          hourlyRate: hourlyRate,
          createdAt: DateTime.now(),
        );

        // Save user to Firestore
        await _firebaseService.addUser(userModel);
        _currentUser = userModel;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to create user';
      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Registration failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
