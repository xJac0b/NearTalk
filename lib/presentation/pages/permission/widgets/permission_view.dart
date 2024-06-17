import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/pages/permission/cubit/permission_cubit.dart';
import 'package:neartalk/presentation/router/routes.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class PermissionView extends StatelessWidget {
  const PermissionView({
    required this.cubit,
    required this.location,
    required this.storage,
    required this.bluetooth,
    super.key,
  });

  final PermissionCubit cubit;
  final bool location;
  final bool storage;
  final bool bluetooth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacings.sixteen.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PermissionCard(
            icon: Icons.location_on,
            granted: location,
            onTap: () => cubit.requestLocation(),
          ),
          PermissionCard(
            icon: Icons.storage,
            granted: storage,
            onTap: () => cubit.requestStorage(),
          ),
          PermissionCard(
            icon: Icons.bluetooth,
            granted: bluetooth,
            onTap: () => cubit.requestBluetooth(),
          ),
          SizedBox(height: AppSpacings.sixteen.h),
          if (location && storage && bluetooth)
            ElevatedButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Continue'),
            )
        ],
      ),
    );
  }
}

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    required this.icon,
    required this.granted,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final bool granted;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsetsX.all(AppSpacings.twelve),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(granted ? 'Granted' : 'Not Granted',
                  style: AppTypography.of(context).body),
            ],
          ),
        ),
      ),
    );
  }
}
