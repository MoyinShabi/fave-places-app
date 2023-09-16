import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageProvider =
    NotifierProvider.autoDispose<ImageNotifier, File>(ImageNotifier.new);

class ImageNotifier extends AutoDisposeNotifier<File> {
  @override
  File build() {
    return File('');
  }

  void setImage(String image) {
    state = File(image);
  }
}
