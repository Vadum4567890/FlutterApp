// edit_article_dialog.dart
// ignore_for_file: library_private_types_in_public_api
// This comment ignores the warning about using private types in public API.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_project/models/article.dart';

class EditArticleDialog extends StatefulWidget {
  final Article article;
  final void Function(String, String, String?) onEdit;

  const EditArticleDialog({required this.article, required this.onEdit});

  @override
  _EditArticleDialogState createState() => _EditArticleDialogState();
}

class _EditArticleDialogState extends State<EditArticleDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    // Initialize the text editing controllers with the article's data
    _titleController = TextEditingController(text: widget.article.title);
    _contentController = TextEditingController(text: widget.article.content);
    _imagePath = widget.article.imagePath;
  }

  @override
  void dispose() {
    // Dispose the text editing controllers to avoid memory leaks
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit article'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text field for editing the article title
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          SizedBox(height: 16.0),
          // Text field for editing the article content
          TextField(
            controller: _contentController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
          SizedBox(height: 16.0),
          // Display the article's image if it exists
          if (_imagePath != null)
            Image.file(
              File(_imagePath!),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        // Save button
        TextButton(
          onPressed: () {
            // Call the onEdit callback with the updated article data
            widget.onEdit(
              _titleController.text,
              _contentController.text,
              _imagePath,
            );
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
