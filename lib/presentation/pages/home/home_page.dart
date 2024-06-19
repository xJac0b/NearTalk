import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:neartalk/presentation/pages/home/cubit/home_cubit.dart';
import 'package:neartalk/presentation/pages/home/widgets/chat_list.dart';
import 'package:neartalk/presentation/pages/home/widgets/connected_chats.dart';
import 'package:neartalk/presentation/pages/home/widgets/connection_request_dialog.dart';
import 'package:neartalk/presentation/router/app_router.dart';
import 'package:neartalk/presentation/router/routes.dart';
import 'package:neartalk/presentation/shared/app_bar_widget.dart';
import 'package:neartalk/presentation/shared/search_field.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<HomeCubit>();
    final state = useBlocBuilder(cubit);
    final searchController = useTextEditingController();
    useListenable(searchController);
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
                  builder: (ctx) => ConnectionRequestDialog(
                      info: info, cubit: cubit, id: id, ctx: context)),
              _ => null,
            });

    return RefreshIndicator(
      onRefresh: () async => cubit.loadChats(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            AppBarWidget(
              pinned: true,
              floating: true,
              title: 'NearTalk',
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(22.h),
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
            if (state.chats.isEmpty) ...[
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
            ] else ...[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacings.twelve.h),
                    Center(
                      child: SearchField(
                        controller: searchController,
                      ),
                    ),
                    SizedBox(height: AppSpacings.twelve.h),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AppSpacings.eight.w),
                      child: Text(
                        'Connected chats',
                        style: AppTypography.of(context).subtitle,
                      ),
                    ),
                    SizedBox(
                      height: AppSpacings.eight.h,
                    ),
                    ConnectedChats(
                      connectedChats: state.connectedChats,
                      searchController: searchController,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AppSpacings.eight.w),
                      child: Text(
                        'All chats',
                        style: AppTypography.of(context).subtitle,
                      ),
                    ),
                    SizedBox(
                      height: AppSpacings.eight.h,
                    ),
                  ],
                ),
              ),
              ChatList(chats: state.chats, searchController: searchController),
            ]
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
