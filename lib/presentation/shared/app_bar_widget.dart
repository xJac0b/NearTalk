import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    this.pinned = false,
    this.floating = false,
    this.title = '',
    this.titleWidget,
    this.actions,
    this.bottom,
    this.centerTitle = false,
    super.key,
  });

  final bool pinned;
  final bool floating;
  final bool centerTitle;
  final Widget? titleWidget;
  final String title;

  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) => SliverAppBar(
        pinned: pinned,
        floating: floating,
        centerTitle: centerTitle,
        toolbarHeight: kToolbarHeight.h,
        title: titleWidget ??
            Text(
              title,
              // style: AppTypography.of(context).body,
            ),
        actions: actions,
        bottom: bottom,
      );
}
