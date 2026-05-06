import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../data/network/api_client.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({this.isLoading = false, this.error, this.isAuthenticated = false});

  AuthState copyWith({bool? isLoading, String? error, bool? isAuthenticated}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthState()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? e.message ?? errorMessage;
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? e.message ?? errorMessage;
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    state = state.copyWith(isAuthenticated: false);
  }
}
