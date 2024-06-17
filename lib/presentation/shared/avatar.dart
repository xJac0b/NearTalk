import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neartalk/gen/assets.gen.dart';
import 'package:neartalk/presentation/shared/extensions/app_theme_extension.dart';
import 'package:neartalk/presentation/styles/app_dimens.dart';

class Avatar extends HookWidget {
  const Avatar({
    required this.path,
    this.uploadAvatar,
    this.radius,
    super.key,
  });
  final String? path;
  final void Function(XFile)? uploadAvatar;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius ?? AppDimens.circleAvatarRadiusSmall,
          backgroundImage: path != null && File(path!).existsSync()
              ? Image.file(File(path!)).image
              : Assets.avatar.image().image,
          backgroundColor: const Color.fromARGB(30, 0, 0, 0),
        ),
        if (uploadAvatar != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.camera,
                color: context.colors.primary,
              ),
              onPressed: () async {
                final result =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (result != null) {
                  uploadAvatar?.call(XFile(result.path));
                } else {
                  // User canceled the picker
                }
              },
            ),
          ),
      ],
    );
  }
}
