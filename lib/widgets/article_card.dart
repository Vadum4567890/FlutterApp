import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_project/models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool canModify;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ArticleCard({
    required this.article,
    required this.canModify,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildImage(),
        title: Text(
          article.title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'by ${article.author}',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        trailing: canModify ? _buildModifyButtons() : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      width: 50,
      height: 50,
      child: article.imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(article.imagePath!),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.red);
                },
              ),
            )
          : const Icon(Icons.image_not_supported, color: Colors.white),
    );
  }

  Widget _buildModifyButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
