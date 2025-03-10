// ignore_for_file: prefer_const_constructors, lines_longer_than_80_chars, library_private_types_in_public_api
// This comment ignores the warnings about:
// - preferring const constructors
// - lines longer than 80 characters
// - using private types in public API

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class AddArticleScreen extends StatefulWidget {
  final void Function(String, String, String?) onAdd;
  const AddArticleScreen({required this.onAdd});

  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _imagePath;

  // Method to pick an image from the device's gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Article')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text field for the article title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            // Text field for the article content
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            // Display the selected image or a placeholder icon
            if (_imagePath != null)
              Image.file(File(_imagePath!), height: 100, width: 100, fit: BoxFit.cover)
            else
              Icon(Icons.image, size: 100),
            // Button to pick an image from the gallery
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            // Button to save the article
            ElevatedButton(
              onPressed: () {
                widget.onAdd(_titleController.text, _contentController.text, _imagePath);
                Navigator.pop(context);
              },
              child: Text('Save Article'),
            ),
          ],
        ),
      ),
    );
  }
}
