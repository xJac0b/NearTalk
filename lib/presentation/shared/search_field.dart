import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    this.controller,
    this.hintText = 'Search',
    super.key,
  });

  final TextEditingController? controller;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTypography.of(context).bodySmall,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: context.colors.inputBackground,
        constraints: BoxConstraints(
          maxWidth: 335.w,
          minWidth: 335.w,
          maxHeight: 37.h,
          minHeight: 37.h,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacings.eight.w),
          child: Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 20.sp,
          ),
        ),
        prefixIconColor: MaterialStateColor.resolveWith(
          (states) => states.contains(MaterialState.focused)
              ? context.colors.primary
              : context.colors.captionText,
        ),
        suffixIconColor: MaterialStateColor.resolveWith(
          (states) => states.contains(MaterialState.focused)
              ? context.colors.primary
              : context.colors.captionText,
        ),
        suffixIcon: controller!.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  FontAwesomeIcons.xmark,
                  size: 20.w,
                ),
                onPressed: () {
                  controller!.clear();
                  FocusScope.of(context).unfocus();
                },
              )
            : null,
      ),
    );
  }
}
