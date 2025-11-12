import 'package:chat_app/feature/account/presentation/ui/edit_profile.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:chat_app/feature/auth/presentation/ui/log_in_page.dart';
import 'package:chat_app/feature/auth/presentation/ui/sign_up_page.dart';
import 'package:chat_app/feature/auth/presentation/ui/user_info_page.dart';
import 'package:chat_app/feature/home/presentation/ui/home.dart';
import 'package:chat_app/feature/splash/presentation/ui/landing_screen.dart';
import 'package:chat_app/feature/splash/presentation/ui/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/landing',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LogInPage(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/user-info',
        name: 'user-info',
        builder: (context, state) => const UserInfoPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) {
          final user = state.extra as UserModel;
          return EditProfileScreen(user: user);
        },
      ),
    ],
  );
}
