// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery_app/bloc/app_bloc.dart';
import 'package:photo_gallery_app/bloc/app_event.dart';
import 'package:photo_gallery_app/bloc/app_state.dart';
import 'package:photo_gallery_app/views/main_pop_up_menu_button.dart';
import 'package:photo_gallery_app/views/storage_image_view.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) return;
              context.read<AppBloc>().add(
                    AppEventUploadImage(
                      filePathToUpload: image.path,
                    ),
                  );
            },
            icon: const Icon(Icons.upload),
            splashRadius: 20,
          ),
          const MainPopUpMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: images
            .map((image) => StorageImageView(
                  image: image,
                ))
            .toList(),
      ),
    );
  }
}
