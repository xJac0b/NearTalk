import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/pages/home/cubit/home_cubit.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class ConnectionRequestDialog extends StatelessWidget {
  const ConnectionRequestDialog({
    required this.info,
    required this.cubit,
    required this.id,
    required this.ctx,
    super.key,
  });

  final ConnectionInfo info;
  final HomeCubit cubit;
  final String id;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsetsX.all(AppSpacings.sixteen),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      backgroundColor: ctx.colors.surface,
      title: Text('Connection request', style: AppTypography.of(ctx).h6),
      content: Text('Do you want to connect with ${info.endpointName}?',
          style: AppTypography.of(ctx).caption),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            cubit.acceptConnection(id, info.endpointName);
          },
          child: Text('Accept', style: AppTypography.of(ctx).buttonSmall),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Nearby().rejectConnection(id);
          },
          child: Text('Reject', style: AppTypography.of(ctx).buttonSmall),
        ),
      ],
    );
  }
}
