import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/patients/presentation/patient_list_screen.dart';
import '../../features/billing/presentation/bill_list_screen.dart';
import '../../features/billing/presentation/bill_details_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      if (!authState.isAuthenticated && !isLoggingIn && !isRegistering) return '/login';
      if (authState.isAuthenticated && (isLoggingIn || isRegistering)) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/patients',
        builder: (context, state) => const PatientListScreen(),
      ),
      GoRoute(
        path: '/bills',
        builder: (context, state) => const BillListScreen(),
        routes: [
          GoRoute(
            path: 'details',
            builder: (context, state) {
              final bill = state.extra as Map<String, dynamic>? ?? {};
              return BillDetailsScreen(bill: bill);
            },
          ),
        ],
      ),
    ],
  );
});
