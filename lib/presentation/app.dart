import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neartalk/core/di/service_locator.dart';
import 'package:neartalk/domain/settings/app_theme_controller.dart';
import 'package:neartalk/presentation/router/app_router.dart';
import 'package:neartalk/presentation/snackbar/snackbar_viewer.dart';
import 'package:neartalk/presentation/styles/theme/app_theme.dart';
import 'package:neartalk/presentation/styles/theme/app_theme_provider.dart';

class App extends HookWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    final platformBrightness = usePlatformBrightness();
    final appTheme = useStream(sl.get<AppThemeController>().stream).data;

    return ScreenUtilInit(
      builder: (_, child) => MaterialApp.router(
        builder: (context, child) => AppThemeProvider(
          appTheme: AppTheme.fromType(appTheme, platformBrightness),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(child: child ?? const SizedBox()),
                  // const BluetoothChecker(),
                ],
              ),
              const SnackbarViewer(),
            ],
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: sl.get<AppRouter>().router,
        themeMode: appTheme ?? ThemeMode.system,
        theme: AppTheme.light().theme,
        darkTheme: AppTheme.dark().theme,
      ),
    );
  }
}
