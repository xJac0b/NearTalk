import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neartalk/presentation/pages/permission/cubit/permission_cubit.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class SplashView extends HookWidget {
  const SplashView({required this.cubit, super.key});

  final PermissionCubit cubit;

  @override
  Widget build(BuildContext context) {
    useSingleTickerProvider();
    final visible = useState(false);
    useEffect(() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      Future.delayed(const Duration(seconds: 3), () {
        cubit.init();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        visible.value = true;
      });
      return null;
    }, []);

    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: visible.value ? 1 : 0,
        child: Container(
            width: double.infinity,
            color: context.colors.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child:
                        Text('NearTalk', style: AppTypography.of(context).h2),
                  ),
                ),
                LoadingAnimationWidget.bouncingBall(
                    color: context.colors.text, size: 50.w),
                SizedBox(height: AppSpacings.thirtyTwo.h)
              ],
            )),
      ),
    );
  }
}
