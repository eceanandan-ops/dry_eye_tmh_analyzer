import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() => runApp(const DryEyeTMHAnalyzer());

class DryEyeTMHAnalyzer extends StatelessWidget {
  const DryEyeTMHAnalyzer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dry Eye TMH Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  final picker = ImagePicker();
  String tmhResult = "";

  Future<void> _captureImage() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = basename(picked.path);
      final savedImage = await File(picked.path).copy('${dir.path}/$fileName');
      setState(() {
        _imageFile = savedImage;
        tmhResult = _generateRandomTMH();
      });
    }
  }

  String _generateRandomTMH() {
    final value = (0.15 + (0.3 - 0.15) * (DateTime.now().millisecond / 1000))
        .toStringAsFixed(2);
    return "$value mm (simulated)";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dry Eye TMH Analyzer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!)
                : const Icon(Icons.remove_red_eye, size: 120, color: Colors.grey),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture & Analyze Eye"),
              onPressed: _captureImage,
            ),
            const SizedBox(height: 16),
            if (tmhResult.isNotEmpty)
              Text("TMH Value: $tmhResult",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
