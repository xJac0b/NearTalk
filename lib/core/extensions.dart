import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

extension EdgeInsetsX on EdgeInsets {
  static EdgeInsets all(double value) =>
      EdgeInsets.symmetric(horizontal: value.w, vertical: value.h);
}

extension DateTimeExtension on DateTime {
  String formatX(BuildContext context) {
    final dateDifference = DateTime.now().difference(this);
    final fromToday = dateDifference.inDays == 0;
    final fromThisYear = dateDifference.inDays < 365;
    return fromToday
        ? DateFormat('hh:mm').format(this)
        : fromThisYear
            ? DateFormat('MMM d').format(this)
            : DateFormat('MMM d, y').format(this);
  }
}
