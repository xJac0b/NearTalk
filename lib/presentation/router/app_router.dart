import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/presentation/pages/chat/chat_page.dart';
import 'package:neartalk/presentation/pages/chat_info/chat_info_page.dart';
import 'package:neartalk/presentation/pages/gallery/gallery_page.dart';
import 'package:neartalk/presentation/pages/home/home_page.dart';
import 'package:neartalk/presentation/pages/permission/permission_page.dart';
import 'package:neartalk/presentation/pages/scan/scan_page.dart';
import 'package:neartalk/presentation/pages/settings/pages/name/name_page.dart';
import 'package:neartalk/presentation/pages/settings/pages/theme/theme_page.dart';
import 'package:neartalk/presentation/pages/settings/settings_page.dart';
import 'package:neartalk/presentation/router/routes.dart';

part 'app_router.g.dart';

// GoRouter configuration
@singleton
class AppRouter {
  GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: Routes.permission,
    routes: $appRoutes,
  );
}

@TypedGoRoute<HomeRoute>(
  path: Routes.home,
  routes: [
    TypedGoRoute<SettingsRoute>(
      path: Routes.settings,
      routes: [
        TypedGoRoute<NameRoute>(path: Routes.name),
        TypedGoRoute<ThemeRoute>(path: Routes.theme),
      ],
    ),
  ],
)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

class NameRoute extends GoRouteData {
  const NameRoute({this.id = ''});
  final String id;
  @override
  Widget build(BuildContext context, GoRouterState state) => NamePage(id: id);
}

class ThemeRoute extends GoRouteData {
  const ThemeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ThemePage();
}

@TypedGoRoute<ScanRoute>(
  path: Routes.scan,
)
class ScanRoute extends GoRouteData {
  const ScanRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ScanPage();
}

@TypedGoRoute<GalleryRoute>(
  path: Routes.gallery,
)
class GalleryRoute extends GoRouteData {
  const GalleryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final (initialIndex, galleryItems, chatName) =
        state.extra! as (int, List<String>, String);
    return GalleryPage(
      initialIndex: initialIndex,
      galleryItems: galleryItems,
      chatName: chatName,
    );
  }
}

@TypedGoRoute<ChatRoute>(
  path: Routes.chat,
  routes: [
    TypedGoRoute<ChatInfoRoute>(
      path: Routes.chatInfo,
    ),
  ],
)
class ChatRoute extends GoRouteData {
  const ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final id = (state.extra as String?) ?? '';
    return ChatPage(id);
  }
}

class ChatInfoRoute extends GoRouteData {
  const ChatInfoRoute(this.id);
  final String id;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatInfoPage(id);
  }
}

@TypedGoRoute<PermissionRoute>(
  path: Routes.permission,
)
class PermissionRoute extends GoRouteData {
  const PermissionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PermissionPage();
}
