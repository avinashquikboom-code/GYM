import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/services/storage_service.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final String userName;
  final String userEmail;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    required this.userName,
    required this.userEmail,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    String? userName,
    String? userEmail,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final StorageService _storageService;

  AuthNotifier(this._storageService)
      : super(AuthState(
          isAuthenticated: _storageService.isLoggedIn(),
          userName: _storageService.getUserName(),
          userEmail: _storageService.getUserEmail(),
        ));

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate Network Request Delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email and password cannot be empty',
      );
      return false;
    }

    if (!email.contains('@')) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid email address',
      );
      return false;
    }

    // Success Mock (Accept any credentials for this demonstration)
    await _storageService.setLoggedIn(true);
    await _storageService.setUserToken('mock_jwt_token_for_$email');
    await _storageService.setUserEmail(email);
    
    // Split email name as username
    final name = email.split('@')[0];
    final formattedName = name[0].toUpperCase() + name.substring(1);
    await _storageService.setUserName(formattedName);

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      userEmail: email,
      userName: formattedName,
    );
    return true;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate Network Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Please fill in all the fields',
      );
      return false;
    }

    await _storageService.setLoggedIn(true);
    await _storageService.setUserToken('mock_jwt_token_for_$email');
    await _storageService.setUserEmail(email);
    await _storageService.setUserName(name);
    await _storageService.setUserPhone(phone);

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      userEmail: email,
      userName: name,
    );
    return true;
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    state = AuthState(
      isAuthenticated: false,
      userName: 'Guest User',
      userEmail: '',
    );
  }

  Future<void> updateProfile(String name, String email, String phone) async {
    await _storageService.setUserName(name);
    await _storageService.setUserEmail(email);
    await _storageService.setUserPhone(phone);
    state = state.copyWith(
      userName: name,
      userEmail: email,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return AuthNotifier(storageService);
});
