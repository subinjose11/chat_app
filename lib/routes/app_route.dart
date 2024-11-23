import 'package:auto_route/auto_route.dart';

import 'app_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LandingRoute.page, initial: true),
        AutoRoute(page: LogInRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: UserInfoRoute.page),
        AutoRoute(page: HomeRoute.page),
      ];
}
