import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/pages/home/cubit/home_cubit.dart';
import 'package:neartalk/presentation/router/app_router.dart';
import 'package:neartalk/presentation/router/routes.dart';
import 'package:neartalk/presentation/shared/app_bar_widget.dart';
import 'package:neartalk/presentation/shared/avatar.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/styles/app_dimens.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<HomeCubit>();
    final state = useBlocBuilder(cubit);
    useStream(cubit.watchChatUseCase());

    final appLifecycleState = useAppLifecycleState();

    useEffect(() {
      if (appLifecycleState == AppLifecycleState.paused ||
          appLifecycleState == AppLifecycleState.inactive) {
        cubit.enableNotifications();
      } else {
        cubit.disableNotifications();
      }

      return null;
    }, [appLifecycleState]);

    useEffect(
      () {
        cubit.init();
        return null;
      },
      [],
    );

    useActionListener(
        cubit,
        (action) => switch (action) {
              ConnectionRequest(:final id, :final info) => showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        actionsPadding: EdgeInsetsX.all(AppSpacings.sixteen),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        backgroundColor: context.colors.surface,
                        title: Text('Connection request',
                            style: AppTypography.of(context).h6),
                        content: Text(
                            'Do you want to connect with ${info.endpointName}?',
                            style: AppTypography.of(context).caption),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              cubit.acceptConnection(id, info.endpointName);
                            },
                            child: Text('Accept',
                                style: AppTypography.of(context).buttonSmall),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Nearby().rejectConnection(id);
                            },
                            child: Text('Reject',
                                style: AppTypography.of(context).buttonSmall),
                          ),
                        ],
                      )),
              _ => null,
            });

    return RefreshIndicator(
      onRefresh: () async => cubit.loadChats(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            AppBarWidget(
              centerTitle: true,
              pinned: true,
              floating: true,
              title: 'NearTalk',
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20.h),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        state.isVisible ? 'Visible' : 'Not visible',
                        style: AppTypography.of(context).caption,
                      ),
                    ]),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                  ),
                  onPressed: () => const SettingsRoute().go(context),
                ),
              ],
            ),
            if (state.chats.isEmpty)
              SliverFillRemaining(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon(Icons.people, size: 40.w),
                    SizedBox(height: AppSpacings.eight.h),
                    Text(
                      'No chats yet',
                      style: AppTypography.of(context).subtitle,
                    ),
                  ])),
            SliverList.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return Padding(
                  padding: EdgeInsets.only(top: AppSpacings.six.h),
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    leading: Avatar(
                      path: chat.avatarPath,
                      radius: AppDimens.circleAvatarRadiusMedium,
                    ),
                    title: Text(chat.name.isEmpty ? chat.id : chat.name,
                        style: AppTypography.of(context).subtitle),
                    subtitle: chat.messages.isEmpty
                        ? null
                        : Text(
                            chat.messages.last.text.isEmpty
                                ? 'Photo'
                                : chat.messages.last.text,
                            style: AppTypography.of(context).caption,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                    trailing: chat.messages.isEmpty
                        ? null
                        : Text(chat.messages.last.timestamp.formatX(context),
                            style: AppTypography.of(context).caption),
                    onTap: () => context.push(Routes.chat, extra: chat.id),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(Routes.scan),
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }
}
