import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/settings/use_cases/get_visibility_use_case.dart';
import 'package:neartalk/domain/settings/use_cases/save_visibility_use_case.dart';
import 'package:rxdart/rxdart.dart';

class VisibilityController {
  VisibilityController._(this._saveVisibilityUseCase);

  @factoryMethod
  static Future<VisibilityController> create(
    GetVisibilityUseCase getVisibilityUseCase,
    SaveVisibilityUseCase saveVisibilityUseCase,
  ) async {
    final initialThemeType = getVisibilityUseCase();
    final instance = VisibilityController._(saveVisibilityUseCase);
    await instance._initialize(initialThemeType);
    return instance;
  }

  late final BehaviorSubject<bool> _visibilitySubject;
  final SaveVisibilityUseCase _saveVisibilityUseCase;

  Stream<bool> get stream => _visibilitySubject.stream;
  bool get isVisible => _visibilitySubject.value;

  Future<void> _initialize(bool isVisible) async {
    _visibilitySubject = BehaviorSubject.seeded(isVisible);
  }

  void changeVisibility({required bool isVisible}) {
    _visibilitySubject.add(isVisible);
    _saveVisibilityUseCase(isVisible: isVisible);
  }
}
