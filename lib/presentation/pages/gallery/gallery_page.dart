import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:neartalk/presentation/shared/loading_indicator.dart';
import 'package:neartalk/presentation/snackbar/snackbar_controller.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPage extends HookWidget {
  const GalleryPage({
    required this.galleryItems,
    required this.initialIndex,
    required this.chatName,
    super.key,
  });

  final String chatName;
  final List<String> galleryItems;
  final int initialIndex;
  @override
  Widget build(BuildContext context) {
    final showAppBar = useState(true);
    final controller = usePageController(initialPage: initialIndex);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: showAppBar.value
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              toolbarHeight: kToolbarHeight.h,
              backgroundColor: Colors.transparent,
              title:
                  Text(chatName, style: const TextStyle(color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.download,
                      color: Colors.white),
                  onPressed: () {
                    if (controller.page == null) return;
                    final int index = controller.page!.round();
                    ImageGallerySaver.saveFile(galleryItems[index])
                        .then((value) {
                      SnackbarController.showNoticiation(
                          'Image saved to gallery');
                    });
                  },
                ),
              ],
            )
          : null,
      body: InkWell(
        onTap: () => showAppBar.value = !showAppBar.value,
        child: Stack(children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(File(galleryItems[index])),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: galleryItems[index]),
              );
            },
            itemCount: galleryItems.length,

            loadingBuilder: (context, event) => ColoredBox(
              color: Colors.black,
              child: LoadingIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
            // backgroundDecoration: backgroundDecoration,
            pageController: controller,
            // onPageChanged: onPageChanged,
          ),
        ]),
      ),
    );
  }
}
