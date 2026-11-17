import 'package:flutter/material.dart';

import '../demo.dart';
import '../models.dart';
import '../widgets.dart';

class StoryStudioScreen extends StatefulWidget {
  const StoryStudioScreen({super.key});

  @override
  State<StoryStudioScreen> createState() => _StoryStudioScreenState();
}

class _StoryStudioScreenState extends State<StoryStudioScreen> {
  final _ideaController = TextEditingController();
  final _characterController = TextEditingController();
  final _moralController = TextEditingController();
  List<StoryScene> _scenes = [];
  bool _loading = false;

  @override
  void dispose() {
    _ideaController.dispose();
    _characterController.dispose();
    _moralController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final idea = _ideaController.text.trim();
    final character = _characterController.text.trim();
    if (idea.isEmpty || character.isEmpty) {
      showSnack(context, 'গল্পের আইডিয়া ও প্রধান চরিত্র লিখুন');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    final scenes = DemoGenerator.story(
      idea: idea,
      character: character,
      moral: _moralController.text.trim().isEmpty
          ? 'সততা ও বন্ধুত্বই সবচেয়ে বড় সম্পদ'
          : _moralController.text.trim(),
    );
    if (!mounted) return;
    setState(() {
      _scenes = scenes;
      _loading = false;
    });
  }

  String get _fullText {
    final b = StringBuffer();
    b.writeln('গল্প: ${_ideaController.text.trim()}');
    b.writeln('চরিত্র: ${_characterController.text.trim()}');
    b.writeln();
    for (final s in _scenes) {
      b.writeln(s.title);
      b.writeln('ছবির প্রম্পট: ${s.imagePrompt}');
      b.writeln('ভয়েসওভার: ${s.voiceover}');
      b.writeln('সাউন্ড এফেক্ট: ${s.sfx}');
      b.writeln();
    }
    return b.toString();
  }

  Future<void> _save() async {
    if (_scenes.isEmpty) return;
    await StorageService.add(
      Project(
        id: StorageService.newId(),
        title: _ideaController.text.trim(),
        type: 'গল্প',
        content: _fullText,
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) showSnack(context, 'গল্প প্রজেক্ট সংরক্ষিত হয়েছে');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('এআই গল্প স্টুডিও'),
        actions: const [DemoChip(), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          TextField(
            controller: _ideaController,
            decoration: const InputDecoration(
              labelText: 'গল্পের আইডিয়া *',
              hintText: 'যেমন: সোনালি বীজের খোঁজে...',
              prefixIcon: Icon(Icons.lightbulb_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _characterController,
            decoration: const InputDecoration(
              labelText: 'প্রধান চরিত্র *',
              hintText: 'যেমন: টমেটো ও আলু',
              prefixIcon: Icon(Icons.person_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _moralController,
            decoration: const InputDecoration(
              labelText: 'গল্পের শিক্ষা (ঐচ্ছিক)',
              hintText: 'যেমন: একতাই শক্তি',
              prefixIcon: Icon(Icons.school_outlined),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_loading ? 'গল্প তৈরি হচ্ছে...' : 'গল্প তৈরি করুন'),
            ),
          ),
          const SizedBox(height: 20),
          if (_scenes.isNotEmpty) ...[
            Row(
              children: [
                const Expanded(
                  child: SectionTitle(title: 'দৃশ্য-দৃশ্যে গল্প'),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_outlined),
                  tooltip: 'সব কপি করুন',
                  onPressed: () => copyText(context, _fullText),
                ),
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  tooltip: 'সংরক্ষণ করুন',
                  onPressed: _save,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._scenes.map((s) => _SceneCard(scene: s)),
          ] else
            const EmptyState(
              icon: Icons.auto_stories_outlined,
              title: 'এখনো কোনো গল্প তৈরি হয়নি',
              subtitle:
                  'উপরে আইডিয়া ও চরিত্র লিখে "গল্প তৈরি করুন" বোতামে চাপ দিন। ছবির প্রম্পট, ভয়েসওভার ও সাউন্ড এফেক্টসহ ৫টি দৃশ্য পাবেন।',
            ),
        ],
      ),
    );
  }
}

class _SceneCard extends StatelessWidget {
  final StoryScene scene;

  const _SceneCard({required this.scene});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.movie_outlined, color: color.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    scene.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_outlined, size: 20),
                  tooltip: 'এই দৃশ্য কপি করুন',
                  onPressed: () => copyText(
                    context,
                    '${scene.title}\nছবির প্রম্পট: ${scene.imagePrompt}\nভয়েসওভার: ${scene.voiceover}\nসাউন্ড এফেক্ট: ${scene.sfx}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _Row(label: 'ছবির প্রম্পট', value: scene.imagePrompt),
            const SizedBox(height: 6),
            _Row(label: 'ভয়েসওভার', value: scene.voiceover),
            const SizedBox(height: 6),
            _Row(label: 'সাউন্ড এফেক্ট', value: scene.sfx),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
