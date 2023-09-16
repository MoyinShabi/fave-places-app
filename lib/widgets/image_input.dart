import 'dart:io';

import 'package:fave_places_app/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/image_preview_screen.dart';

class ImageInput extends ConsumerStatefulWidget {
  const ImageInput({super.key});

  @override
  ConsumerState<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends ConsumerState<ImageInput> {
  Future<void> takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    ref.read(imageProvider.notifier).setImage(pickedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    final File? selectedImage = ref.watch(imageProvider);

    Widget content = TextButton.icon(
      onPressed: takePicture,
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    if (selectedImage?.path != '') {
      content = Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) =>
                    ImagePreviewScreen(selectedImage: selectedImage),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton.filledTonal(
              onPressed: takePicture,
              icon: Icon(
                Icons.camera_alt_rounded,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
            ),
          ),
        ],
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          // width: 4,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: content,
    );
  }
}
