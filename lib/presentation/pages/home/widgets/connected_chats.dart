import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/router/routes.dart';
import 'package:neartalk/presentation/shared/avatar.dart';
import 'package:neartalk/presentation/styles/app_dimens.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class ConnectedChats extends StatelessWidget {
  const ConnectedChats({
    required this.connectedChats,
    required this.searchController,
    super.key,
  });

  final List<({String chatId, String? avatarPath, String name})> connectedChats;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 105.h),
      child: connectedChats.isEmpty
          ? Center(
              child: Text(
                'No connected chats',
                style: AppTypography.of(context).caption,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: connectedChats.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final chat = connectedChats[index];
                if (chat.name
                    .toLowerCase()
                    .trim()
                    .contains(searchController.text.toLowerCase().trim())) {
                  return Padding(
                    padding: EdgeInsetsX.all(AppSpacings.eight),
                    child: InkWell(
                      onTap: () => context.push(
                        Routes.chat,
                        extra: chat.chatId,
                      ),
                      child: SizedBox(
                        width: 70.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Avatar(
                              path: chat.avatarPath,
                              radius: AppDimens.circleAvatarRadiusLarge,
                            ),
                            Text(
                              chat.name,
                              style: AppTypography.of(context).caption,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}
