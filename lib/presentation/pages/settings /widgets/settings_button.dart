import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    required this.text,
    this.onTap,
    this.leading,
    this.trailing,
    super.key,
  });

  final String? text;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsX.all(AppSpacings.sixteen),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                leading ?? const SizedBox(),
                SizedBox(width: AppSpacings.sixteen.w),
                Text(text ?? '', style: AppTypography.of(context).body),
              ],
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
