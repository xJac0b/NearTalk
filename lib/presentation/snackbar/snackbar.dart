import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/snackbar/snackbar_message.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class CustomSnackbar extends StatelessWidget {
  const CustomSnackbar({
    required this.icon,
    required this.text,
    required this.onDismissed,
    required this.dismissible,
    this.type = SnackbarType.info,
    super.key,
  });

  final IconData icon;
  final String text;
  final SnackbarType type;
  final VoidCallback onDismissed;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: DismissibleOrNot(
        onDismissed: onDismissed,
        dismissible: dismissible,
        child: Material(
          elevation: AppSpacings.zero,
          type: MaterialType.transparency,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsetsX.all(AppSpacings.twelve),
              child: PhysicalModel(
                color: switch (type) {
                  SnackbarType.successful => context.colors.correct,
                  SnackbarType.error => context.colors.error,
                  SnackbarType.warning => context.colors.warning,
                  _ => context.colors.primary
                },
                borderRadius: BorderRadius.circular(AppSpacings.fourteen.r),
                elevation: 16,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: AppSpacings.thirtyTwo,
                    minWidth: MediaQuery.sizeOf(context).width,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: 48.w,
                        child: Icon(
                          icon,
                          size: AppSpacings.fourteen.sp,
                          color: context.colors.buttonText,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppSpacings.eight.h),
                          child: Text(
                            text,
                            style: AppTypography.of(context).body.copyWith(
                                  color: context.colors.buttonText,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacings.sixteen.w),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DismissibleOrNot extends StatelessWidget {
  const DismissibleOrNot({
    required this.dismissible,
    required this.onDismissed,
    required this.child,
    super.key,
  });
  final bool dismissible;
  final VoidCallback onDismissed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (dismissible) {
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (_) => onDismissed(),
        direction: DismissDirection.horizontal,
        child: child,
      );
    }
    return child;
  }
}
