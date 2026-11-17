import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models.dart';
import '../widgets.dart';

class _TextLayer {
  String text;
  Offset offset;
  double fontSize;
  Color color;
  bool bold;

  _TextLayer({
    required this.text,
    required this.offset,
    required this.fontSize,
    required this.color,
    required this.bold,
  });
}

class PosterStudioScreen extends StatefulWidget {
  const PosterStudioScreen({super.key});

  @override
  State<PosterStudioScreen> createState() => _PosterStudioScreenState();
}

class _PosterStudioScreenState extends State<PosterStudioScreen> {
  final _canvasKey = GlobalKey();
  final _headlineController = TextEditingController(text: 'বড় খবর!');
  final _subController = TextEditingController(text: 'বিস্তারিত ভেতরে...');
  File? _image;
  int _selected = 0;
  bool _exporting = false;

  final _layers = [
    _TextLayer(
      text: 'বড় খবর!',
      offset: const Offset(24, 24),
      fontSize: 40,
      color: Colors.white,
      bold: true,
    ),
    _TextLayer(
      text: 'বিস্তারিত ভেতরে...',
      offset: const Offset(24, 220),
      fontSize: 22,
      color: Colors.white,
      bold: false,
    ),
  ];

  static const _colors = [
    Colors.white,
    Colors.black,
    Colors.yellow,
    Colors.red,
    Colors.teal,
    Colors.blue,
    Colors.pink,
    Colors.green,
  ];

  @override
  void dispose() {
    _headlineController.dispose();
    _subController.dispose();
    super.dispose();
  }

  _TextLayer get _current => _layers[_selected];

  Future<void> _pickImage() async {
    try {
      final picked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _image = File(picked.path));
      }
    } catch (_) {
      if (mounted) showSnack(context, 'ছবি বাছাই করা যায়নি। আবার চেষ্টা করুন।');
    }
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final boundary = _canvasKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final bytes =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes!.buffer.asUint8List());
      if (mounted) showSnack(context, 'ছবি সংরক্ষিত হয়েছে: ${file.path}');
    } catch (_) {
      if (mounted) showSnack(context, 'এক্সপোর্ট করা যায়নি। আবার চেষ্টা করুন।');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _saveProject() async {
    await StorageService.add(
      Project(
        id: StorageService.newId(),
        title: _headlineController.text.trim().isEmpty
            ? 'নতুন পোস্টার'
            : _headlineController.text.trim(),
        type: 'পোস্টার',
        content:
            'শিরোনাম: ${_headlineController.text}\nসাবটাইটেল: ${_subController.text}\nছবি: ${_image == null ? 'কোনো ছবি নেই' : 'গ্যালারি থেকে বাছাই করা'}',
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) showSnack(context, 'পোস্টার প্রজেক্ট সংরক্ষিত হয়েছে');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পোস্টার স্টুডিও'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library_outlined),
            tooltip: 'গ্যালারি থেকে ছবি',
            onPressed: _pickImage,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Canvas
          RepaintBoundary(
            key: _canvasKey,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: _image == null
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0F766E), Color(0xFF1D4ED8)],
                        )
                      : null,
                  image: _image == null
                      ? null
                      : DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      if (_image == null)
                        const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: Colors.white70,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'ছবি বেছে নিন অথবা এই ব্যাকগ্রাউন্ড ব্যবহার করুন',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      for (var i = 0; i < _layers.length; i++)
                        Positioned(
                          left: _layers[i].offset.dx,
                          top: _layers[i].offset.dy,
                          child: GestureDetector(
                            onTap: () => setState(() => _selected = i),
                            onPanUpdate: (d) {
                              setState(() {
                                final o = _layers[i].offset + d.delta;
                                _layers[i].offset = Offset(
                                  o.dx.clamp(0.0, 260.0),
                                  o.dy.clamp(0.0, 260.0),
                                );
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: _selected == i
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: Colors.amber,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.black
                                          .withValues(alpha: 0.15),
                                    )
                                  : null,
                              child: Text(
                                _layers[i].text,
                                style: TextStyle(
                                  fontSize: _layers[i].fontSize,
                                  color: _layers[i].color,
                                  fontWeight: _layers[i].bold
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 6,
                                      color: Colors.black54,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'লেখার ওপর ট্যাপ করে সিলেক্ট করুন, টেনে সরান।',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          // Layer selector
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('শিরোনাম')),
              ButtonSegment(value: 1, label: Text('সাবটাইটেল')),
            ],
            selected: {_selected},
            onSelectionChanged: (s) => setState(() => _selected = s.first),
          ),
          const SizedBox(height: 12),
          TextField(
            controller:
                _selected == 0 ? _headlineController : _subController,
            decoration: InputDecoration(
              labelText: _selected == 0 ? 'শিরোনামের লেখা' : 'সাবটাইটেলের লেখা',
            ),
            onChanged: (v) => setState(() => _current.text = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('অক্ষরের সাইজ'),
              Expanded(
                child: Slider(
                  value: _current.fontSize,
                  min: 14,
                  max: 64,
                  divisions: 25,
                  label: _current.fontSize.round().toString(),
                  onChanged: (v) => setState(() => _current.fontSize = v),
                ),
              ),
              Text(toBnDigits(_current.fontSize.round().toString())),
            ],
          ),
          Row(
            children: [
              const Text('রঙ'),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: _colors.map((c) {
                    final selected = _current.color == c;
                    return GestureDetector(
                      onTap: () => setState(() => _current.color = c),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.withValues(alpha: 0.4),
                            width: selected ? 3 : 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('মোটা (বোল্ড) লেখা'),
            value: _current.bold,
            contentPadding: EdgeInsets.zero,
            onChanged: (v) => setState(() => _current.bold = v),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _exporting ? null : _export,
              icon: _exporting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download_outlined),
              label: Text(_exporting ? 'এক্সপোর্ট হচ্ছে...' : 'ছবি হিসেবে এক্সপোর্ট করুন'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _saveProject,
              icon: const Icon(Icons.save_outlined),
              label: const Text('প্রজেক্ট হিসেবে সংরক্ষণ করুন'),
            ),
          ),
        ],
      ),
    );
  }
}
