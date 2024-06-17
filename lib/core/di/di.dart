import 'package:injecteo/injecteo.dart';
import 'package:neartalk/core/di/di.config.dart';
import 'package:neartalk/core/di/service_locator.dart';

@InjecteoConfig(preferRelativeImports: false)
Future<void> configureDependencies(String env) async => $injecteoConfig(
      sl,
      environment: env,
    );
