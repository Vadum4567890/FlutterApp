import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_project/cubit/article_list/article_cubit.dart';
import 'package:my_project/widgets/gradient_background.dart';
import 'package:my_project/widgets/gradient_button.dart';
import 'package:my_project/widgets/image_picker_widget.dart';
import 'package:my_project/widgets/transparent_app_bar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final imagePathNotifier = ValueNotifier<String?>(null);

  Future<String?> _saveImage(String sourcePath) async {
    try {
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(sourcePath);
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final newFilePath = p.join(appDocumentsDir.path, uniqueFileName);
      await File(sourcePath).copy(newFilePath);
      return newFilePath;
    } catch (e) {
      return null;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final savedPath = await _saveImage(pickedFile.path);
    if (!mounted) return;

    if (savedPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save image')),
      );
      return;
    }

    imagePathNotifier.value = savedPath;
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

    context.read<ArticleCubit>().addArticle(
          title,
          content,
          imagePathNotifier.value,
        );
    Navigator.pop(context);
  }

  InputDecoration inputDecoration(String label, String hint) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TransparentAppBar(
        title: 'Add Article',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: GradientBackground(
        colors: [Colors.blueAccent, Colors.purpleAccent],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration('Title', 'Enter the title'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration('Content', 'Enter the content'),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                ImagePickerWidget(
                  imagePathNotifier: imagePathNotifier,
                  onPickImage: pickImage,
                ),
                const SizedBox(height: 30),
                GradientButton(
                  text: 'Save Article',
                  icon: Icons.save,
                  onPressed: saveArticle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
