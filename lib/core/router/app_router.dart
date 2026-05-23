import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_tumor/ai_tumor_screen.dart';
import '../../features/articles/article_detail_screen.dart';
import '../../features/articles/articles_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/faq/faq_screen.dart';
import '../../features/history/scan_history_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/health_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/profile_setup_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../auth/auth_refresh.dart';
import '../services/auth_service.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const resetPassword = '/reset-password';
  static const profileSetup = '/profile-setup';
  static const home = '/home';
  static const history = '/history';
  static const articles = '/articles';
  static const profile = '/profile';
  static const aiTumor = '/ai-tumor';
  static const healthProfile = '/health-profile';
  static const faq = '/faq';
  static const articleDetail = '/articles/:id';

  static String articleDetailPath(String id) => '/articles/$id';
}

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>();

bool _isAuthRoute(String location) {
  return location == AppRoutes.login ||
      location == AppRoutes.signup ||
      location == AppRoutes.onboarding;
}

bool _isPublicRoute(String location) {
  return location == AppRoutes.splash ||
      _isAuthRoute(location) ||
      location == AppRoutes.resetPassword;
}

bool _isProfileSetupExempt(String location) {
  return location == AppRoutes.profileSetup ||
      location == AppRoutes.healthProfile ||
      location == AppRoutes.resetPassword ||
      location.startsWith('/articles/');
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: AppRoutes.splash,
  refreshListenable: authRefreshListenable,
  redirect: (context, state) {
    final loggedIn = AuthService.instance.isLoggedIn;
    final location = state.matchedLocation;

    if (location == AppRoutes.splash) {
      return null;
    }

    if (!loggedIn && !_isPublicRoute(location)) {
      return AppRoutes.login;
    }

    if (loggedIn && _isAuthRoute(location)) {
      return AuthService.instance.postAuthRoute;
    }

    if (loggedIn &&
        AuthService.instance.needsHealthProfileSetup &&
        !_isProfileSetupExempt(location) &&
        location != AppRoutes.splash) {
      return AppRoutes.profileSetup;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, _) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (_, _) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (_, _) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (_, state) {
        final email = state.uri.queryParameters['email'];
        return ResetPasswordScreen(initialEmail: email);
      },
    ),
    GoRoute(
      path: AppRoutes.profileSetup,
      builder: (_, _) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.aiTumor,
      builder: (_, _) => const AiTumorScreen(),
    ),
    GoRoute(
      path: AppRoutes.healthProfile,
      builder: (_, _) => const HealthProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.faq,
      builder: (_, _) => const FaqScreen(),
    ),
    GoRoute(
      path: AppRoutes.articleDetail,
      builder: (_, state) {
        final id = state.pathParameters['id'] ?? '';
        return ArticleDetailScreen(articleId: id);
      },
    ),
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (_, _, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (_, _) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: AppRoutes.history,
          pageBuilder: (_, _) =>
              const NoTransitionPage(child: ScanHistoryScreen()),
        ),
        GoRoute(
          path: AppRoutes.articles,
          pageBuilder: (_, _) =>
              const NoTransitionPage(child: ArticlesScreen()),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (_, _) =>
              const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
  ],
);
