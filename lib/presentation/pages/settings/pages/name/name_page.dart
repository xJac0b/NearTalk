import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:neartalk/core/extensions.dart';
import 'package:neartalk/presentation/pages/settings/pages/name/cubit/name_cubit.dart';
import 'package:neartalk/presentation/shared/loading_indicator.dart';
import 'package:neartalk/presentation/styles/app_spacings.dart';
import 'package:neartalk/presentation/styles/app_typography.dart';

class NamePage extends HookWidget {
  const NamePage({required this.id, super.key});
  final String id;
  @override
  Widget build(BuildContext context) {
    final cubit = useBloc<NameCubit>();
    final state = useBlocBuilder(cubit);
    final name = useTextEditingController();

    useEffect(
      () {
        cubit.loadName(id, name);
        return null;
      },
      [],
    );

    return Scaffold(
      body: state.maybeMap(
          error: (value) => const Center(child: Text('Something went wrong')),
          loading: (value) => const Center(child: LoadingIndicator()),
          orElse: () => CustomScrollView(
                slivers: [
                  SliverAppBar(
                    centerTitle: true,
                    title: const Text(
                      'Name',
                    ),
                    toolbarHeight: kToolbarHeight.h,
                  ),
                  SliverPadding(
                    padding: EdgeInsetsX.all(AppSpacings.twentyFour),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        TextField(
                          controller: name,
                          style: AppTypography.of(context).body,
                          decoration: const InputDecoration(
                            labelText: 'Device name',
                          ),
                        ),
                        SizedBox(height: AppSpacings.twentyFour.h),
                        state.maybeMap(
                          loading: (_) => const ElevatedButton(
                            onPressed: null,
                            child: LoadingIndicator(),
                          ),
                          orElse: () => ElevatedButton(
                            onPressed: () => {
                              FocusScope.of(context).unfocus(),
                              cubit.changeName(name.text.trim())
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              )),
    );
  }
}
