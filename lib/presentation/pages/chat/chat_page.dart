import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/pages/chat/cubit/chat_cubit.dart';
import 'package:neartalk/presentation/pages/chat/widget/message_input.dart';
import 'package:neartalk/presentation/router/app_router.dart';
import 'package:neartalk/presentation/router/routes.dart';
import 'package:neartalk/presentation/shared/avatar.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/styles/app_dimens.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class ChatPage extends HookWidget {
  const ChatPage(this.id, {super.key});
  final String id;
  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<ChatCubit>();
    final state = useBlocBuilder(cubit);
    useStream(cubit.watchChat(id));
    useEffect(() {
      cubit.init(id);
      return null;
    }, []);

    return Scaffold(
      appBar: state.mapOrNull(
        (state) => AppBar(
          toolbarHeight: kToolbarHeight.h,
          title: InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: () => ChatInfoRoute(id).push<void>(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Avatar(
                  path: state.chat.avatarPath,
                ),
                SizedBox(width: AppSpacings.twelve.w),
                Text(
                  state.chat.name.isEmpty ? state.chat.id : state.chat.name,
                  style: AppTypography.of(context).subtitle,
                )
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.circleInfo),
              onPressed: () => ChatInfoRoute(id).push<void>(context),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.h),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    state.isConnected ? 'Connected' : 'Disconnected',
                    style: AppTypography.of(context).caption,
                  ),
                ]),
          ),
        ),
      ),
      body: state.map(
        (state) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                cacheExtent: 1000,
                reverse: true,
                itemBuilder: (context, index) {
                  final messages = state.chat.messages.reversed.toList();
                  final nextSame =
                      index > 0 && messages[index].me == messages[index - 1].me;
                  final prevSame = index + 1 < messages.length &&
                      messages[index].me == messages[index + 1].me;
                  final message = messages[index];

                  final showDateAlways = index == messages.length - 1 ||
                      (index < messages.length - 1 &&
                          messages[index]
                                  .timestamp
                                  .difference(messages[index + 1].timestamp)
                                  .inMinutes >
                              5);
                  final bool isMe = message.me;
                  return Padding(
                    padding: EdgeInsets.only(
                        left: AppSpacings.twelve.w,
                        right: AppSpacings.twelve.w,
                        bottom:
                            nextSame ? AppSpacings.two.h : AppSpacings.eight.h),
                    child: Column(
                      children: [
                        if (showDateAlways)
                          Text(
                            message.timestamp.formatX(context),
                            style: AppTypography.of(context)
                                .caption
                                .copyWith(color: context.colors.hint),
                          ),
                        Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (isMe)
                                const SizedBox()
                              else
                                nextSame
                                    ? SizedBox(
                                        width:
                                            AppDimens.circleAvatarRadiusSmall *
                                                2,
                                      )
                                    : Avatar(
                                        radius:
                                            AppDimens.circleAvatarRadiusSmall,
                                        path: state.chat.avatarPath,
                                      ),
                              SizedBox(
                                width: AppSpacings.six.w,
                              ),
                              InkWell(
                                splashFactory: NoSplash.splashFactory,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  if (!message.sent && state.isConnected) {
                                    cubit.removeMessage(message.id);
                                    if (message.path != null) {
                                      cubit.sendFile(XFile(message.path!));
                                    } else {
                                      cubit.sendMessage(message.text);
                                    }
                                  }
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 0.8.sw,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacings.twelve.w,
                                      vertical: AppSpacings.six.h,
                                    ),
                                    decoration: message.path != null
                                        ? null
                                        : BoxDecoration(
                                            color: isMe
                                                ? context.colors.primary
                                                    .withOpacity(
                                                        message.sent ? 1 : 0.3)
                                                : context.colors.surfaceBright
                                                    .withOpacity(
                                                        message.sent ? 1 : 0.3),
                                            borderRadius: BorderRadius.only(
                                              topLeft: !isMe && prevSame
                                                  ? Radius.zero
                                                  : Radius.circular(24.r),
                                              topRight: isMe && prevSame
                                                  ? Radius.zero
                                                  : Radius.circular(24.r),
                                              bottomLeft:
                                                  isMe || (!isMe && !nextSame)
                                                      ? Radius.circular(24.r)
                                                      : Radius.zero,
                                              bottomRight:
                                                  (isMe && !nextSame) || !isMe
                                                      ? Radius.circular(24.r)
                                                      : Radius.zero,
                                            ),
                                          ),
                                    child: Column(
                                      children: [
                                        if (message.path != null)
                                          ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight: 0.5.sh,
                                                maxWidth: 0.5.sw,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  context.push(Routes.gallery,
                                                      extra: (
                                                        state.chat.paths
                                                            .indexOf(
                                                                message.path!),
                                                        state.chat.paths,
                                                        state.chat.name,
                                                      ));
                                                },
                                                child: Image.file(
                                                  File(message.path!),
                                                  frameBuilder: (context,
                                                          child,
                                                          frame,
                                                          wasSynchronouslyLoaded) =>
                                                      frame == null
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator())
                                                          : child,
                                                ),
                                              )),
                                        Text(
                                          message.text,
                                          textAlign: isMe
                                              ? TextAlign.end
                                              : TextAlign.start,
                                          style: AppTypography.of(context)
                                              .bodySmall
                                              .copyWith(
                                                color: (isMe
                                                        ? context
                                                            .colors.buttonText
                                                        : context.colors.text)
                                                    .withOpacity(
                                                        message.sent ? 1 : 0.5),
                                              ),
                                        ),
                                        if (!message.sent)
                                          Text(
                                            state.isConnected
                                                ? 'Click to resend'
                                                : 'Connect to send',
                                            textAlign: isMe
                                                ? TextAlign.end
                                                : TextAlign.start,
                                            style: AppTypography.of(context)
                                                .caption
                                                .copyWith(
                                                    color: context.colors.hint),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  );
                },
                itemCount: state.chat.messages.length,
              ),
            ),
            MessageInput(
              cubit: cubit,
            ),
          ],
        ),
        error: (_) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
