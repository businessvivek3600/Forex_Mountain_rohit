import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  final String label;
  final void Function(File? file)? onImagePicked;

  const CustomImagePicker({
    super.key,
    required this.label,
    this.onImagePicked,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(_pickedImage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Row(
          children: [
            _pickedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _pickedImage!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _pickedImage != null
                    ? "Image Selected"
                    : widget.label,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const Icon(Icons.upload_file, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
