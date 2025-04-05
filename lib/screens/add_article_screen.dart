// ignore_for_file: always_put_required_named_parameters_first

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddArticleScreen extends StatefulWidget {
  final void Function(String, String, String?) onAdd;

  const AddArticleScreen({super.key, required this.onAdd});

  @override
  State<AddArticleScreen> createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveArticle() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    widget.onAdd(title, content, _imagePath);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Article')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            if (_imagePath != null)
              Image.file(File(_imagePath!), height: 100, width: 100, fit: BoxFit.cover)
            else
              const Icon(Icons.image, size: 100),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveArticle,
              child: const Text('Save Article'),
            ),
          ],
        ),
      ),
    );
  }
}
