import 'dart:ui';

import 'package:neartalk/presentation/styles/colors/app_colors.dart';

class DarkAppColor extends BaseColors {
  const DarkAppColor()
      : super(
          primary: const Color(0xff5d5ed0),
          surface: const Color(0xFF171A1F),
          surfaceBright: const Color(0xFF1E2228),
          text: const Color(0xffE7E7E7),
          captionText: const Color(0xffCCCCCC),
          buttonText: const Color(0xffFFFFFF),
          inputBackground: const Color(0xFF272A33),
          error: const Color(0xffBB0000),
          hint: const Color(0xffAAAAAA),
          correct: const Color(0xff00BB00),
          warning: const Color(0xffDD8300),
          remove: const Color(0xffAA0000),
          tabIndicator: const Color(0xFF171A1F),
        );
}
