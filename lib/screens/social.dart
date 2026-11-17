import 'package:flutter/material.dart';

import '../demo.dart';
import '../models.dart';
import '../widgets.dart';

class SocialAssistantScreen extends StatefulWidget {
  const SocialAssistantScreen({super.key});

  @override
  State<SocialAssistantScreen> createState() => _SocialAssistantScreenState();
}

class _SocialAssistantScreenState extends State<SocialAssistantScreen> {
  final _topicController = TextEditingController();
  String _platform = DemoGenerator.platforms.first;
  SocialPack? _pack;
  bool _loading = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      showSnack(context, 'অনুগ্রহ করে একটি টপিক লিখুন');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _pack = DemoGenerator.social(topic: topic, platform: _platform);
      _loading = false;
    });
  }

  Future<void> _save() async {
    final pack = _pack;
    if (pack == null) return;
    await StorageService.add(
      Project(
        id: StorageService.newId(),
        title: _topicController.text.trim(),
        type: 'সোশ্যাল',
        content:
            'ক্যাপশন:\n${pack.caption}\n\nটাইটেল:\n${pack.title}\n\nবিবরণ:\n${pack.description}\n\nহ্যাশট্যাগ:\n${pack.hashtags}\n\nপোস্ট আইডিয়া:\n${pack.ideas.map((e) => '• $e').join('\n')}',
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) showSnack(context, 'পোস্ট প্রজেক্ট সংরক্ষিত হয়েছে');
  }

  @override
  Widget build(BuildContext context) {
    final pack = _pack;
    return Scaffold(
      appBar: AppBar(
        title: const Text('সোশ্যাল মিডিয়া সহকারী'),
        actions: const [DemoChip(), SizedBox(width: 8)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          TextField(
            controller: _topicController,
            decoration: const InputDecoration(
              labelText: 'পোস্টের টপিক *',
              hintText: 'যেমন: শীতের পিঠা উৎসব',
              prefixIcon: Icon(Icons.topic_outlined),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _platform,
            decoration: const InputDecoration(labelText: 'প্ল্যাটফর্ম'),
            items: DemoGenerator.platforms
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _platform = v!),
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
              label: Text(_loading ? 'তৈরি হচ্ছে...' : 'কনটেন্ট তৈরি করুন'),
            ),
          ),
          const SizedBox(height: 20),
          if (pack != null) ...[
            _PackSection(
              icon: Icons.text_fields_outlined,
              title: 'ক্যাপশন',
              body: pack.caption,
            ),
            _PackSection(
              icon: Icons.title_outlined,
              title: 'টাইটেল',
              body: pack.title,
            ),
            _PackSection(
              icon: Icons.description_outlined,
              title: 'বিবরণ',
              body: pack.description,
            ),
            _PackSection(
              icon: Icons.tag_outlined,
              title: 'হ্যাশট্যাগ',
              body: pack.hashtags,
            ),
            _PackSection(
              icon: Icons.lightbulb_outlined,
              title: 'পোস্ট আইডিয়া',
              body: pack.ideas.map((e) => '• $e').join('\n'),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('প্রজেক্ট হিসেবে সংরক্ষণ করুন'),
              ),
            ),
          ] else
            const EmptyState(
              icon: Icons.share_outlined,
              title: 'এখনো কোনো কনটেন্ট তৈরি হয়নি',
              subtitle:
                  'টপিক লিখে বোতামে চাপ দিন — ক্যাপশন, টাইটেল, বিবরণ, হ্যাশট্যাগ ও পোস্ট আইডিয়া পাবেন।',
            ),
        ],
      ),
    );
  }
}

class _PackSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _PackSection({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_outlined, size: 20),
                  tooltip: 'কপি করুন',
                  onPressed: () => copyText(context, body),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SelectableText(body, style: const TextStyle(height: 1.6)),
          ],
        ),
      ),
    );
  }
}
