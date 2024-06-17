import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/core/app_bloc_observer.dart';
import 'package:neartalk/core/di/di.dart';
import 'package:neartalk/core/di/service_locator.dart';
import 'package:neartalk/domain/uid/uid_repository.dart';
import 'package:neartalk/presentation/app.dart';
import 'package:path_provider/path_provider.dart';

Directory appDocumentsDir = Directory('');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory documentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentDirectory.path);

  await configureDependencies(Environment.prod);
  Bloc.observer = const AppBlocObserver();

  sl<UidRepository>().setUid();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  appDocumentsDir = await getApplicationDocumentsDirectory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetoothy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HookedBlocConfigProvider(injector: () => sl, child: const App()),
    );
  }
}
