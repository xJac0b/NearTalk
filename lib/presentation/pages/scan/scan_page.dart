import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/pages/scan/cubit/scan_cubit.dart';
import 'package:neartalk/presentation/pages/scan/cubit/scan_result.dart';
import 'package:neartalk/presentation/router/routes.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/shared/loading_indicator.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class ScanPage extends HookWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<ScanCubit>();
    final state = useBlocBuilder(cubit);

    final extended = useState<Set<String>>({});

    useEffect(
      () {
        cubit.init();
        return null;
      },
      [],
    );

    final scanResults = state.scanResults;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scanning for devices'),
        toolbarHeight: kToolbarHeight.h,
      ),
      body: Padding(
        padding: EdgeInsetsX.all(AppSpacings.eight),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: scanResults.length,
                itemBuilder: (context, index) {
                  final element = scanResults.entries.elementAt(index);
                  final id = element.key;
                  final extended0 = extended.value.contains(id);
                  final connected =
                      element.value.state == DeviceState.connected;
                  final state = element.value.state;
                  final name = element.value.name;
                  return Padding(
                    padding: EdgeInsetsX.all(AppSpacings.two),
                    child: ColoredBox(
                      color: switch (state) {
                        DeviceState.connected =>
                          context.colors.primary.withOpacity(0.1),
                        DeviceState.rejected =>
                          context.colors.error.withOpacity(0.1),
                        DeviceState.error =>
                          context.colors.error.withOpacity(0.1),
                        _ => context.colors.surfaceBright,
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListTile(
                              contentPadding:
                                  EdgeInsetsX.all(AppSpacings.eight),
                              leading: state == DeviceState.requested
                                  ? const LoadingIndicator()
                                  : const Icon(Icons.smartphone),
                              title: Text(
                                name,
                                style: AppTypography.of(context).body,
                              ),
                              subtitle: connected
                                  ? Text('Connected',
                                      style: AppTypography.of(context)
                                          .subtitleSmall)
                                  : null,
                              trailing: extended0
                                  ? const Icon(FontAwesomeIcons.angleUp)
                                  : const Icon(FontAwesomeIcons.angleDown),
                              onTap: () {
                                if (extended.value.contains(id)) {
                                  extended.value = {...extended.value}
                                    ..remove(id);
                                } else {
                                  extended.value = {...extended.value, id};
                                }
                              },
                            ),
                            if (extended.value.contains(id))
                              Padding(
                                  padding: EdgeInsetsX.all(AppSpacings.eight),
                                  child: switch (state) {
                                    DeviceState.connected => Wrap(
                                          spacing: AppSpacings.eight.w,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  final deviceId = await cubit
                                                      .writeMessage(id, name);
                                                  if (deviceId == null) return;
                                                  if (context.mounted) {
                                                    context.pop();
                                                    await context.push(
                                                        Routes.chat,
                                                        extra: deviceId);
                                                  }
                                                },
                                                child: const Text(
                                                    'Write message')),
                                            ElevatedButton(
                                                onPressed: () =>
                                                    cubit.disconnect(id),
                                                child:
                                                    const Text('Disconnect')),
                                          ]),
                                    DeviceState.idle => ElevatedButton(
                                        onPressed: () =>
                                            cubit.requestConnection(id),
                                        child: const Text('Connect')),
                                    DeviceState.requested => Text(
                                        'Waiting for response...',
                                        style:
                                            AppTypography.of(context).caption,
                                      ),
                                    DeviceState.rejected => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Rejected',
                                                style: AppTypography.of(context)
                                                    .bodySmall
                                                    .copyWith(
                                                        color: context
                                                            .colors.error)),
                                            SizedBox(
                                                width: AppSpacings.eight.w),
                                            Icon(FontAwesomeIcons.ban,
                                                color: context.colors.error)
                                          ]),
                                    DeviceState.error => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Error',
                                                style: AppTypography.of(context)
                                                    .bodySmall
                                                    .copyWith(
                                                        color: context
                                                            .colors.error)),
                                            SizedBox(
                                                width: AppSpacings.eight.w),
                                            Icon(
                                                FontAwesomeIcons
                                                    .circleExclamation,
                                                color: context.colors.error)
                                          ]),
                                  })
                            else
                              const SizedBox(),
                          ]),
                    ),
                  );
                },
              ),
            ),
            LoadingAnimationWidget.prograssiveDots(
                color: context.colors.text, size: 40.w),
          ],
        ),
      ),
    );
  }
}
