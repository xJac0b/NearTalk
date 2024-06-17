import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:neartalk/presentation/pages/settings%20/pages/theme/cubit/theme_cubit.dart';
import 'package:neartalk/presentation/pages/settings%20/widgets/settings_button.dart';
import 'package:neartalk/presentation/shared/loading_indicator.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';

class ThemePage extends HookWidget {
  const ThemePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<ThemeCubit>();
    final state = useBlocBuilder(cubit);

    useEffect(
      () {
        cubit.init();
        return null;
      },
      [cubit],
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight.h,
        centerTitle: true,
        title: const Text('Theme'),
      ),
      body: state.maybeMap(
        orElse: () => const Center(child: LoadingIndicator()),
        loaded: (state) => Padding(
          padding: const EdgeInsets.all(AppSpacings.twentyFour),
          child: Column(
            children: [
              ThemeButton(
                active: state.themeMode == ThemeMode.light,
                mode: ThemeMode.light,
                changeTheme: cubit.changeTheme,
              ),
              ThemeButton(
                active: state.themeMode == ThemeMode.dark,
                mode: ThemeMode.dark,
                changeTheme: cubit.changeTheme,
              ),
              ThemeButton(
                active: state.themeMode == ThemeMode.system,
                mode: ThemeMode.system,
                changeTheme: cubit.changeTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    required this.mode,
    required this.changeTheme,
    required this.active,
    super.key,
  });

  final ThemeMode mode;
  final bool active;
  final void Function(ThemeMode) changeTheme;

  @override
  Widget build(BuildContext context) => SettingsButton(
        text: switch (mode) {
          ThemeMode.light => 'Light',
          ThemeMode.dark => 'Dark',
          ThemeMode.system => 'System',
        },
        onTap: () => changeTheme(mode),
        trailing: active
            ? Icon(
                FontAwesomeIcons.check,
                color: Colors.grey,
                size: 16.w,
              )
            : null,
      );
}
