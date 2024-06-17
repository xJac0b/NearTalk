import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/use_cases/get_visibility_use_case.dart';
import 'package:neartalk/domain/settings/use_cases/save_visibility_use_case.dart';
import 'package:neartalk/domain/settings/visibility_controller.dart';

@externalModule
abstract class VisibilityModule {
  @preResolve
  @singleton
  Future<VisibilityController> visibility(
    GetVisibilityUseCase getVisibilityUseCase,
    SaveVisibilityUseCase saveVisibilityUseCase,
  ) =>
      VisibilityController.create(getVisibilityUseCase, saveVisibilityUseCase);
}
