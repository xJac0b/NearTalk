import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:neartalk/presentation/pages/permission/cubit/permission_cubit.dart';
import 'package:neartalk/presentation/pages/permission/widgets/permission_view.dart';
import 'package:neartalk/presentation/pages/permission/widgets/splash_view.dart';

class PermissionPage extends HookWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<PermissionCubit>();
    final state = useBlocBuilder(cubit);

    // useEffect(
    //   () {
    //     cubit.init();
    //     return null;
    //   },
    //   [],
    // );

    return state.map(
      initial: (_) => SplashView(
        cubit: cubit,
      ),
      permissions: (permissions) => PermissionView(
        cubit: cubit,
        location: permissions.location,
        storage: permissions.storage,
        bluetooth: permissions.bluetooth,
        wifi: permissions.wifi,
      ),
    );
  }
}
