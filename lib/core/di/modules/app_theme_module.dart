import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/app_theme_controller.dart';
import 'package:neartalk/domain/settings/use_cases/get_app_theme_use_case.dart';
import 'package:neartalk/domain/settings/use_cases/save_app_theme_use_case.dart';

@externalModule
abstract class AppThemeModule {
  @preResolve
  @singleton
  Future<AppThemeController> appThemeController(
    GetAppThemeUseCase getAppColorsUseCase,
    SaveAppThemeUseCase saveAppThemeUseCase,
  ) =>
      AppThemeController.create(getAppColorsUseCase, saveAppThemeUseCase);
}
