import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final ValueNotifier<String?> imagePathNotifier;
  final Future<void> Function() onPickImage;

  const ImagePickerWidget({
    required this.imagePathNotifier,
    required this.onPickImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: ValueListenableBuilder<String?>(
        valueListenable: imagePathNotifier,
        builder: (context, imagePath, _) {
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          color: Colors.red,
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text(
                      'Tap to pick image',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
