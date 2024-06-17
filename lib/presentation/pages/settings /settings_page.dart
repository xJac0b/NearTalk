import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:neartalk/presentation/pages/settings%20/cubit/settings_cubit.dart';
import 'package:neartalk/presentation/pages/settings%20/widgets/settings_button.dart';
import 'package:neartalk/presentation/router/app_router.dart';
import 'package:neartalk/presentation/shared/app_bar_widget.dart';
import 'package:neartalk/presentation/shared/loading_indicator.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';

class SettingsPage extends HookWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<SettingsCubit>();
    final state = useBlocBuilder(cubit);

    useEffect(
      () {
        cubit.init();
        return null;
      },
      [cubit],
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const AppBarWidget(
            title: 'Settings',
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacings.twentyFour),
            sliver: state.maybeMap(
              orElse: () => const SliverToBoxAdapter(child: LoadingIndicator()),
              loaded: (state) => SliverList(
                delegate: SliverChildListDelegate.fixed([
                  SettingsButton(
                    leading: const Icon(
                      FontAwesomeIcons.brush,
                    ),
                    onTap: () => const ThemeRoute().push<void>(context),
                    text: 'Theme',
                    trailing: const AngleRightIcon(),
                  ),
                  SettingsButton(
                    leading: const Icon(
                      FontAwesomeIcons.userTag,
                    ),
                    onTap: () => const NameRoute().push<void>(context),
                    text: 'Name',
                    trailing: const AngleRightIcon(),
                  ),
                  SettingsButton(
                    leading: const Icon(
                      FontAwesomeIcons.eye,
                    ),
                    text: 'Visibility',
                    trailing: Transform.scale(
                      scale: 1.3,
                      child: Switch(
                        value: state.isVisible,
                        onChanged: (value) =>
                            cubit.changeVisibility(isVisible: value),
                      ),
                    ),
                    onTap: null,
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AngleRightIcon extends StatelessWidget {
  const AngleRightIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      FontAwesomeIcons.angleRight,
      color: Colors.grey,
      size: 16,
    );
  }
}
