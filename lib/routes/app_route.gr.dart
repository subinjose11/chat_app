// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:chat_app/feature/auth/presentation/ui/log_in_page.dart' as _i3;
import 'package:chat_app/feature/auth/presentation/ui/sign_up_page.dart' as _i4;
import 'package:chat_app/feature/auth/presentation/ui/user_info_page.dart'
    as _i5;
import 'package:chat_app/feature/home/presentation/ui/home.dart' as _i1;
import 'package:chat_app/feature/landing/presentation/ui/landing_screen.dart'
    as _i2;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomePage(),
      );
    },
    LandingRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.LandingScreen(),
      );
    },
    LogInRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.LogInPage(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SignUpPage(),
      );
    },
    UserInfoRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.UserInfoPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LandingScreen]
class LandingRoute extends _i6.PageRouteInfo<void> {
  const LandingRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LandingRoute.name,
          initialChildren: children,
        );

  static const String name = 'LandingRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.LogInPage]
class LogInRoute extends _i6.PageRouteInfo<void> {
  const LogInRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LogInRoute.name,
          initialChildren: children,
        );

  static const String name = 'LogInRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SignUpPage]
class SignUpRoute extends _i6.PageRouteInfo<void> {
  const SignUpRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i5.UserInfoPage]
class UserInfoRoute extends _i6.PageRouteInfo<void> {
  const UserInfoRoute({List<_i6.PageRouteInfo>? children})
      : super(
          UserInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserInfoRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}
