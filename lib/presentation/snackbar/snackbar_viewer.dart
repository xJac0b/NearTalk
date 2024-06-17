import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:neartalk/presentation/snackbar/cubit/snackbar_cubit.dart';
import 'package:neartalk/presentation/snackbar/snackbar.dart';
import 'package:neartalk/presentation/snackbar/snackbar_message.dart';
import 'package:neartalk/presentation/styles/app_animations.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';

class SnackbarViewer extends HookWidget {
  const SnackbarViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<SnackbarCubit>();
    final state = useBlocBuilder(cubit);

    final controller = useAnimationController(
      duration: AppAnimations.fastAnimation,
      reverseDuration: AppAnimations.fastAnimation,
    );

    useBlocListener(cubit, (_, newState, ___) {
      if (newState is SnackbarStateMessage) controller.forward();
    });

    useActionListener(
      cubit,
      (action) => switch (action) {
        SnackbarActionDismissed() => controller.reverse(),
        SnackbarActionShow() =>
          controller.status == AnimationStatus.dismissed ? cubit.next() : null,
      },
    );

    useEffect(
      () {
        controller.addStatusListener((status) {
          if (status == AnimationStatus.dismissed) cubit.next();
          if (status == AnimationStatus.completed) cubit.countdown();
        });

        cubit.init();

        return cubit.close;
      },
      [cubit],
    );

    return switch (state) {
      SnackbarStateMessage(:final message) => Positioned(
          left: AppSpacings.zero,
          right: AppSpacings.zero,
          // bottom: 0,
          bottom: message.position == SnackbarPosition.bottom
              ? (AppSpacings.zero + MediaQuery.of(context).viewInsets.bottom)
              : null,
          child: SlideTransition(
            position: controller.drive(
              Tween(
                begin: message.position == SnackbarPosition.bottom
                    ? const Offset(AppSpacings.zero, AppSpacings.one)
                    : const Offset(AppSpacings.zero, -AppSpacings.one),
                end: Offset.zero,
              ),
            ),
            child: _SnackbarMessage(
              message: message,
              onClose: () => controller.reverse(),
              dismissible: message.dismissible,
            ),
          ),
        ),
      _ => const SizedBox(),
    };
  }
}

class _SnackbarMessage extends StatelessWidget {
  const _SnackbarMessage({
    required this.message,
    required this.onClose,
    required this.dismissible,
  });

  final SnackbarMessage message;
  final VoidCallback onClose;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomSnackbar(
        text: message.message,
        type: message.type,
        icon: message.icon,
        onDismissed: onClose,
        dismissible: dismissible,
      ),
    );
  }
}
