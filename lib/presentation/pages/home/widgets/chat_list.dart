import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/domain/chat/models/chat.dart';
import 'package:neartalk/presentation/router/routes.dart';
import 'package:neartalk/presentation/shared/avatar.dart';
import 'package:neartalk/presentation/styles/app_dimens.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    required this.chats,
    required this.searchController,
    super.key,
  });

  final List<Chat> chats;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        if (chat.name
            .toLowerCase()
            .trim()
            .contains(searchController.text.toLowerCase().trim())) {
          return Padding(
            padding: EdgeInsets.only(
                top: AppSpacings.eight.h,
                left: AppSpacings.eight.w,
                right: AppSpacings.eight.w,
                bottom: index == chats.length - 1
                    ? AppSpacings.sixtyFour.h
                    : AppSpacings.ten.h),
            child: InkWell(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Avatar(
                    path: chat.avatarPath,
                    radius: AppDimens.circleAvatarRadiusMedium),
                SizedBox(width: AppSpacings.twelve.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.name.isEmpty ? chat.id : chat.name,
                        style: AppTypography.of(context).subtitle),
                    if (chat.messages.isNotEmpty)
                      Text(
                        chat.messages.last.text.isEmpty
                            ? 'Photo'
                            : chat.messages.last.text,
                        style: AppTypography.of(context).caption,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                  ],
                ),
                const Spacer(),
                if (chat.messages.isNotEmpty)
                  Text(chat.messages.last.timestamp.formatX(context),
                      style: AppTypography.of(context).caption),
              ]),
              onTap: () => context.push(Routes.chat, extra: chat.id),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
