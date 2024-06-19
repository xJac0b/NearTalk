import 'dart:ui';

import 'package:neartalk/presentation/styles/colors/app_colors.dart';

class LightAppColor extends BaseColors {
  const LightAppColor()
      : super(
          primary: const Color(0xff5d5ed0),
          surface: const Color(0xFFf1f1f2),
          surfaceBright: const Color(0xFFffffff),
          text: const Color(0xff242424),
          captionText: const Color(0xff606060),
          buttonText: const Color(0xffFFFFFF),
          inputBackground: const Color(0xffE3E5E7),
          error: const Color(0xffFA6650),
          hint: const Color(0xffAAAAAA),
          correct: const Color(0xff00FF00),
          warning: const Color(0xffFFA500),
          remove: const Color(0xffAA0000),
          tabIndicator: const Color(0xffF1F1FE),
        );
}
