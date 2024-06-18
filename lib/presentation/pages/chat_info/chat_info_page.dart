import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/pages/chat_info/cubit/chat_info_cubit.dart';
import 'package:neartalk/presentation/pages/settings/widgets/settings_button.dart';
import 'package:neartalk/presentation/router/app_router.dart';
import 'package:neartalk/presentation/shared/app_bar_widget.dart';
import 'package:neartalk/presentation/shared/avatar.dart';
import 'package:neartalk/presentation/styles/app_dimens.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class ChatInfoPage extends HookWidget {
  const ChatInfoPage(this.id, {super.key});
  final String id;
  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<ChatInfoCubit>();
    final state = useBlocBuilder(cubit);

    useEffect(() {
      cubit.init(id);
      return null;
    }, []);

    return Scaffold(
      body: state.map(
          (value) => CustomScrollView(
                slivers: [
                  const AppBarWidget(
                    pinned: true,
                  ),
                  SliverFillRemaining(
                    child: Padding(
                      padding: EdgeInsetsX.all(AppSpacings.twelve),
                      child: Column(children: [
                        SizedBox(height: AppSpacings.sixteen.h),
                        Avatar(
                          path: value.chat.avatarPath,
                          radius: AppDimens.circleAvatarRadius,
                          uploadAvatar: (file) async {
                            await cubit.updateAvatar(value.chat.id, file);
                            await cubit.loadChat(id);
                          },
                        ),
                        SizedBox(height: AppSpacings.sixteen.h),
                        Text(
                          value.chat.name,
                          style: AppTypography.of(context).h4,
                        ),
                        SizedBox(height: AppSpacings.sixteen.h),
                        Column(children: [
                          SettingsButton(
                            leading: const Icon(
                              FontAwesomeIcons.userTag,
                            ),
                            text: 'Rename chat',
                            onTap: () async {
                              await NameRoute(id: id).push<void>(context);
                              await cubit.loadChat(id);
                            },
                          ),
                          SettingsButton(
                            leading: const Icon(
                              FontAwesomeIcons.trash,
                            ),
                            text: 'Remove chat',
                            onTap: () {
                              cubit.deleteChat(id);
                              context.pop();
                              context.pop();
                            },
                          ),
                          if (value.isConnected)
                            SettingsButton(
                                text: 'Disconnect',
                                leading: const Icon(FontAwesomeIcons.xmark),
                                onTap: () =>
                                    cubit.disconnect(value.chat.endpointId))
                        ]),
                      ]),
                    ),
                  )
                ],
              ),
          error: (value) => Center(child: Text(value.error))),
    );
  }
}
