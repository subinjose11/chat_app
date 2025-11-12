// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:chat_app/feature/account/presentation/ui/edit_profile.dart'
    as _i1;
import 'package:chat_app/feature/auth/data/model/user_model.dart' as _i10;
import 'package:chat_app/feature/auth/presentation/ui/log_in_page.dart' as _i4;
import 'package:chat_app/feature/auth/presentation/ui/sign_up_page.dart' as _i5;
import 'package:chat_app/feature/auth/presentation/ui/user_info_page.dart'
    as _i7;
import 'package:chat_app/feature/home/presentation/ui/home.dart' as _i2;
import 'package:chat_app/feature/splash/presentation/ui/landing_screen.dart'
    as _i3;
import 'package:chat_app/feature/splash/presentation/ui/splash_screen.dart'
    as _i6;
import 'package:flutter/material.dart' as _i9;

/// generated route for
/// [_i1.EditProfileScreen]
class EditProfileRoute extends _i8.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i9.Key? key,
    required _i10.UserModel user,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         EditProfileRoute.name,
         args: EditProfileRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'EditProfileRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditProfileRouteArgs>();
      return _i1.EditProfileScreen(key: args.key, user: args.user);
    },
  );
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({this.key, required this.user});

  final _i9.Key? key;

  final _i10.UserModel user;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.LandingScreen]
class LandingRoute extends _i8.PageRouteInfo<void> {
  const LandingRoute({List<_i8.PageRouteInfo>? children})
    : super(LandingRoute.name, initialChildren: children);

  static const String name = 'LandingRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.LandingScreen();
    },
  );
}

/// generated route for
/// [_i4.LogInPage]
class LogInRoute extends _i8.PageRouteInfo<void> {
  const LogInRoute({List<_i8.PageRouteInfo>? children})
    : super(LogInRoute.name, initialChildren: children);

  static const String name = 'LogInRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.LogInPage();
    },
  );
}

/// generated route for
/// [_i5.SignUpPage]
class SignUpRoute extends _i8.PageRouteInfo<void> {
  const SignUpRoute({List<_i8.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignUpPage();
    },
  );
}

/// generated route for
/// [_i6.SplashPage]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute({List<_i8.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SplashPage();
    },
  );
}

/// generated route for
/// [_i7.UserInfoPage]
class UserInfoRoute extends _i8.PageRouteInfo<void> {
  const UserInfoRoute({List<_i8.PageRouteInfo>? children})
    : super(UserInfoRoute.name, initialChildren: children);

  static const String name = 'UserInfoRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.UserInfoPage();
    },
  );
}
