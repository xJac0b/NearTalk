import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:neartalk/presentation/pages/permission/cubit/permission_cubit.dart';
import 'package:neartalk/presentation/pages/permission/widgets/permission_view.dart';
import 'package:neartalk/presentation/router/routes.dart';

class PermissionPage extends HookWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<PermissionCubit>();
    final state = useBlocBuilder(cubit);

    useActionListener(
        cubit,
        (action) => switch (action) {
              GoHome() => context.go(Routes.home),
              _ => null,
            });

    useEffect(
      () {
        cubit.init();
        return null;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight.h,
        centerTitle: true,
        title: const Text('Bluetoothy'),
        actions: const [],
      ),
      body: state.map(
        initial: (_) => const Center(child: CircularProgressIndicator()),
        permissions: (permissions) => PermissionView(
          cubit: cubit,
          location: permissions.location,
          storage: permissions.storage,
          bluetooth: permissions.bluetooth,
        ),
      ),
    );
  }
}
