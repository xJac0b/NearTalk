import 'package:flutter/material.dart';
import 'package:neartalk/presentation/styles/app_dimens.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color,
    this.value,
  });
  final Color? color;
  final double? value;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppDimens.progressIndicatorSize,
      child: CircularProgressIndicator(
        value: value,
        color: color,
        strokeWidth: AppDimens.progressIndicatorStrokeWidth,
      ),
    );
  }
}
