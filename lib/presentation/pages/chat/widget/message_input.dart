import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:neartalk/presentation/pages/chat/cubit/chat_cubit.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class MessageInput extends HookWidget {
  const MessageInput({
    required this.cubit,
    super.key,
  });

  final ChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    useListenable(controller);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        color: context.colors.surface,
        padding: EdgeInsets.only(
          left: AppSpacings.twelve.w,
          right: AppSpacings.twelve.w,
          bottom: AppSpacings.six.h,
        ),
        child: TextField(
          style: AppTypography.of(context).bodySmall,
          controller: controller,
          minLines: 1,
          maxLines: 4,
          decoration: InputDecoration(
              prefixIcon: controller.text.isEmpty
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: AppSpacings.eight.w),
                      child: InkWell(
                        child: Icon(FontAwesomeIcons.camera,
                            size: AppSpacings.twenty.sp),
                        onTap: () {
                          Logger().d('Camera clicked');
                          ImagePicker()
                              .pickImage(
                            source: ImageSource.camera,
                            requestFullMetadata: false,
                          )
                              .then((result) {
                            if (result != null) {
                              cubit.sendFile(result);
                              Logger().d(result.path);
                            }
                          });
                        },
                      ),
                    )
                  : null,
              hintText: 'Type a message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              suffixIcon: Padding(
                  padding: EdgeInsets.only(right: AppSpacings.eight.w),
                  child: controller.text.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSpacings.eight.w),
                          child: InkWell(
                            child: Icon(
                              FontAwesomeIcons.image,
                              size: AppSpacings.twenty.sp,
                            ),
                            onTap: () {
                              ImagePicker()
                                  .pickImage(
                                requestFullMetadata: false,
                                source: ImageSource.gallery,
                              )
                                  .then((result) {
                                if (result != null) {
                                  cubit.sendFile(result);
                                  Logger().d(result.path);
                                }
                              });
                              Logger().d('Image clicked');
                            },
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSpacings.eight.w),
                          child: InkWell(
                            child: Icon(
                              FontAwesomeIcons.paperPlane,
                              size: AppSpacings.twenty.sp,
                            ),
                            onTap: () {
                              Logger().d('PaperPlane clicked');
                              cubit.sendMessage(controller.text);
                              controller.clear();
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ))),
        ),
      ),
    );
  }
}
