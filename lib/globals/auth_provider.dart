import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:building_site_build_by_vishal/models/user_model.dart';
import 'package:building_site_build_by_vishal/globals/demo_data.dart';
import 'package:building_site_build_by_vishal/globals/data_provider.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class AuthProvider extends ChangeNotifier {
  AuthProvider();

  factory AuthProvider.of(BuildContext context, {bool listen = false}) {
    return Provider.of<AuthProvider>(context, listen: listen);
  }

  UserModel? _currentUser;

  bool _isLoading = false;

  String? _errorMessage;

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
      await Future.delayed(const Duration(seconds: 1));

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
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        role: role,
        skills: skills,
        hourlyRate: hourlyRate,
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
