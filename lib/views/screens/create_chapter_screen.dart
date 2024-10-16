import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resonate/models/chapter.dart';

class CreateChapterScreen extends StatefulWidget {
  final Function(Chapter) onChapterCreated;

  const CreateChapterScreen({super.key, required this.onChapterCreated});

  @override
  _CreateChapterScreenState createState() => _CreateChapterScreenState();
}

class _CreateChapterScreenState extends State<CreateChapterScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  File? chapterCoverImage;
  File? audioFile; // For audio file
  File? lyricsFile; // For lyrics text file

  Future<void> pickChapterCoverImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        chapterCoverImage = File(selectedImage.path);
      });
    }
  }

  Future<void> pickAudioFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      setState(() {
        audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> pickLyricsFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      setState(() {
        lyricsFile = File(result.files.single.path!);
      });
    }
  }

  void createChapter() {
    if (titleController.text.isEmpty || aboutController.text.isEmpty) {
      // Show error if required fields are not filled
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all required fields.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    // Create a new chapter instance
    final newChapter = Chapter(
      'chapterId_${DateTime.now().millisecondsSinceEpoch}', // Dummy chapter ID
      titleController.text,
      chapterCoverImage?.path ?? '',
      aboutController.text,
      lyricsFile?.path ??
          '', // Use the selected lyrics file path or empty if not selected
      audioFile?.path ??
          '', // Use the selected audio file path or empty if not selected
      '5 min', // Placeholder for play duration
      Colors.blue, // Placeholder for tint color
    );

    widget.onChapterCreated(newChapter);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Create a Chapter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Chapter Title *'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: aboutController,
              maxLength: 2000,
              decoration:
                  const InputDecoration(labelText: 'About *', counterText: ''),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickChapterCoverImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: chapterCoverImage != null
                    ? Image.file(
                        chapterCoverImage!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Text(
                          'Select Chapter Cover Image',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickAudioFile,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    audioFile != null
                        ? 'Audio File Selected: ${audioFile!.path.split('/').last}'
                        : 'Upload Audio File',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickLyricsFile,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    lyricsFile != null
                        ? 'Lyrics File Selected: ${lyricsFile!.path.split('/').last}'
                        : 'Upload Lyrics File',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createChapter,
              child: const Text('Create Chapter'),
            ),
          ],
        ),
      ),
    );
  }
}
