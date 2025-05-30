// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/cubit/article_list/article_cubit.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AddArticleScreen extends StatelessWidget {
  const AddArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final imagePathNotifier = ValueNotifier<String?>(null);

    Future<void> pickImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final appDocumentsDir = await getApplicationDocumentsDirectory();
        final fileName = p.basename(pickedFile.path);
        final uniqueFileName =
            '${DateTime.now().millisecondsSinceEpoch}_$fileName';
        final newFilePath = p.join(appDocumentsDir.path, uniqueFileName);

        try {
          final savedImage = await File(pickedFile.path).copy(newFilePath);
          imagePathNotifier.value = savedImage.path;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save image: ${e.toString()}')),
          );
        }
      }
    }

    void saveArticle() {
      final title = titleController.text.trim();
      final content = contentController.text.trim();

      if (title.isEmpty || content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title and content cannot be empty')),
        );
        return;
      }

      context
          .read<ArticleCubit>()
          .addArticle(title, content, imagePathNotifier.value);
      Navigator.pop(context);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Article'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Title', 'Enter the title'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Content', 'Enter the content'),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImage,
                  child: ValueListenableBuilder<String?>(
                    valueListenable: imagePathNotifier,
                    builder: (context, imagePath, _) {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.2),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.5)),
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
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Save Article',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: saveArticle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white70),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
